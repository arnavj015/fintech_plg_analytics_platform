#!/usr/bin/env python3
"""
Generate realistic seed data with intentional data quality issues.
This makes the dbt project more realistic and tests data quality handling.

Data Quality Issues Introduced:
- 5% of user_ids have whitespace (in users table only)
- Duplicate user_ids (intentional duplicates, "last wins" strategy)
- Inconsistent casing in plan_type
- 3% of transactions reference missing users (orphan transactions)
- 2% of timestamps are malformed (will fail DuckDB cast - truly invalid formats)
- 1-2% duplicate transaction_ids (replay/retry scenario)
- 2% duplicate events (no event_id - dedupe by user_id+event_type+event_time)
- Late-arriving events (events before signup or way in the future)
- Users changing plans mid-stream (for snapshot testing)
"""

import csv
import random
from datetime import datetime, timedelta
from faker import Faker

fake = Faker()
random.seed(42)  
Faker.seed(42)

NUM_USERS = 50
NUM_TRANSACTIONS = 150
NUM_EVENTS = 300
PLAN_TYPES = ['free', 'premium', 'enterprise']
EVENT_TYPES = ['login', 'page_view', 'transaction', 'feature_used', 'upgrade_clicked']

# Data quality issue rates
WHITESPACE_USER_ID_RATE = 0.05
ORPHAN_TRANSACTION_RATE = 0.03
MALFORMED_TIMESTAMP_RATE = 0.02
LATE_ARRIVING_EVENT_RATE = 0.08
INCONSISTENT_CASING_RATE = 0.15
DUPLICATE_TRANSACTION_ID_RATE = 0.015  # 1.5% duplicate transaction_ids
DUPLICATE_EVENT_RATE = 0.02  # 2% duplicate events (no event_id makes this realistic)

# Track actual counts of issues
issue_counts = {
    'whitespace_user_ids': 0,
    'duplicate_user_ids': 0,
    'inconsistent_casing': 0,
    'orphan_transactions': 0,
    'malformed_timestamps': 0,
    'late_arriving_events': 0,
    'duplicate_transaction_ids': 0,
    'duplicate_events': 0,
    'dirty_id_references': 0  # Transactions/events referencing dirty user_ids
}

# Maintain canonical user IDs (clean, stable)
canonical_user_ids = [str(i) for i in range(1, NUM_USERS + 1)]
start_date = datetime(2024, 1, 1)
end_date = datetime(2024, 3, 31)

# Generate users
users = []
dirty_user_id_map = {}  # Maps canonical ID to dirty variant

for i in range(1, NUM_USERS + 1):
    canonical_id = str(i)
    user_id = canonical_id
    
    # 5% have whitespace issues (only in users table)
    if random.random() < WHITESPACE_USER_ID_RATE:
        issue_counts['whitespace_user_ids'] += 1
        if random.random() < 0.5:
            user_id = f" {canonical_id} "  # Leading/trailing whitespace
        else:
            user_id = f"{canonical_id}\t"  # Tab character
        dirty_user_id_map[canonical_id] = user_id
    
    signup_date = fake.date_between(start_date=start_date, end_date=end_date)
    plan_type = random.choice(PLAN_TYPES)
    
    # 15% have inconsistent casing
    if random.random() < INCONSISTENT_CASING_RATE:
        issue_counts['inconsistent_casing'] += 1
        casing_style = random.choice(['UPPER', 'Title', 'MiXeD'])
        if casing_style == 'UPPER':
            plan_type = plan_type.upper()
        elif casing_style == 'Title':
            plan_type = plan_type.title()
        elif casing_style == 'MiXeD':
            plan_type = ''.join(c.upper() if random.random() < 0.5 else c.lower() 
                              for c in plan_type)
    
    users.append({
        'user_id': user_id,
        'signup_date': signup_date.strftime('%Y-%m-%d'),
        'plan_type': plan_type
    })

# Add some duplicate user_ids (intentional duplicates)
duplicate_count = max(1, NUM_USERS // 20)
issue_counts['duplicate_user_ids'] = duplicate_count
for _ in range(duplicate_count):
    dup_user = random.choice(users)
    users.append({
        'user_id': dup_user['user_id'],
        'signup_date': fake.date_between(start_date=start_date, end_date=end_date).strftime('%Y-%m-%d'),
        'plan_type': random.choice(PLAN_TYPES)
    })

# Build user lookup for plan/date info
# "Last wins" strategy: duplicates overwrite previous values
# This simulates plan changes and ensures latest record is the "current" truth
user_lookup = {}
for u in users:
    clean_id = u['user_id'].strip()
    # Always overwrite (last wins) - simulates plan changes and latest ingestion
    user_lookup[clean_id] = {
        'plan_type': u['plan_type'].lower(),
        'signup_date': datetime.strptime(u['signup_date'], '%Y-%m-%d')
    }

# Generate transactions
transactions = []
transaction_ids_used = set()
orphan_user_ids = [9999, 8888, 7777, 6666, 5555]  # Non-existent user IDs

print("Generating transactions...")
for i in range(1, NUM_TRANSACTIONS + 1):
    transaction_id = f"tx{i:04d}"
    
    # 1.5% duplicate transaction_ids (replay/retry scenario)
    if random.random() < DUPLICATE_TRANSACTION_ID_RATE and transaction_ids_used:
        issue_counts['duplicate_transaction_ids'] += 1
        transaction_id = random.choice(list(transaction_ids_used))
    else:
        transaction_ids_used.add(transaction_id)
    
    # Choose user_id: mostly canonical, sometimes dirty, sometimes orphan
    rand = random.random()
    if rand < ORPHAN_TRANSACTION_RATE:
        # 3% are orphan transactions (reference missing users)
        issue_counts['orphan_transactions'] += 1
        user_id = str(random.choice(orphan_user_ids))
    elif rand < ORPHAN_TRANSACTION_RATE + 0.02:  # 2% reference dirty IDs
        # Small rate referencing dirty IDs (to test normalization)
        issue_counts['dirty_id_references'] += 1
        if dirty_user_id_map:
            user_id = random.choice(list(dirty_user_id_map.values()))
        else:
            user_id = str(random.choice(canonical_user_ids))
    else:
        # Most reference canonical IDs
        user_id = str(random.choice(canonical_user_ids))
    
    # Amount based on plan type (if user exists)
    clean_user_id = user_id.strip()
    user_plan = user_lookup.get(clean_user_id, {}).get('plan_type')
    
    if user_plan == 'enterprise':
        amount = round(random.uniform(200, 400), 2)
    elif user_plan == 'premium':
        amount = round(random.uniform(50, 150), 2)
    else:
        amount = round(random.uniform(0, 10), 2)  # Free tier or orphan
    
    # Generate timestamp
    timestamp = fake.date_time_between(start_date=start_date, end_date=end_date)
    
    # 2% have malformed timestamps (will fail DuckDB cast)
    if random.random() < MALFORMED_TIMESTAMP_RATE:
        issue_counts['malformed_timestamps'] += 1
        malformed_style = random.choice(['invalid_format', 'empty_string', 'wrong_separator', 'text'])
        if malformed_style == 'invalid_format':
            timestamp_str = timestamp.strftime('%d/%m/%Y %H:%M')  # Wrong format (DD/MM/YYYY)
        elif malformed_style == 'empty_string':
            timestamp_str = ''  # Empty string (will fail cast)
        elif malformed_style == 'wrong_separator':
            # Truly invalid: impossible date/time values
            timestamp_str = '2024-13-40 99:99:99'  # Invalid month, day, hour, minute
        else:  # text
            timestamp_str = 'invalid_timestamp'  # Text that can't be cast
    else:
        timestamp_str = timestamp.strftime('%Y-%m-%d %H:%M:%S')
    
    transactions.append({
        'transaction_id': transaction_id,
        'user_id': user_id,
        'amount': str(amount),
        'timestamp': timestamp_str
    })

# Generate events
events = []
event_signatures = set()  # Track (user_id, event_type, event_time) for duplicate detection
print("Generating events...")
for i in range(1, NUM_EVENTS + 1):
    # Mostly canonical IDs, small rate of dirty IDs
    if random.random() < 0.02 and dirty_user_id_map:
        issue_counts['dirty_id_references'] += 1
        user_id = random.choice(list(dirty_user_id_map.values()))
    else:
        user_id = str(random.choice(canonical_user_ids))
    
    event_type = random.choice(EVENT_TYPES)
    clean_user_id = user_id.strip()
    user_signup = user_lookup.get(clean_user_id, {}).get('signup_date')
    
    if user_signup:
        # 8% are late-arriving events
        if random.random() < LATE_ARRIVING_EVENT_RATE:
            issue_counts['late_arriving_events'] += 1
            if random.random() < 0.5:
                # Event before signup
                event_time = fake.date_time_between(
                    start_date=user_signup - timedelta(days=30),
                    end_date=user_signup - timedelta(days=1)
                )
            else:
                # Event way in the future
                event_time = fake.date_time_between(
                    start_date=end_date + timedelta(days=1),
                    end_date=end_date + timedelta(days=90)
                )
        else:
            # Normal event after signup
            event_time = fake.date_time_between(
                start_date=user_signup,
                end_date=end_date
            )
    else:
        event_time = fake.date_time_between(start_date=start_date, end_date=end_date)
    
    # 2% have malformed timestamps (will fail DuckDB cast)
    if random.random() < MALFORMED_TIMESTAMP_RATE:
        issue_counts['malformed_timestamps'] += 1
        malformed_style = random.choice(['invalid_format', 'empty_string', 'wrong_separator', 'text'])
        if malformed_style == 'invalid_format':
            event_time_str = event_time.strftime('%m-%d-%Y %H:%M')  # Wrong format (MM-DD-YYYY)
        elif malformed_style == 'empty_string':
            event_time_str = ''  # Empty string (will fail cast)
        elif malformed_style == 'wrong_separator':
            # Truly invalid: impossible date/time values or malformed ISO
            event_time_str = '2024-03-01T12:00:00Zzz'  # Invalid ISO suffix
        else:  # text
            event_time_str = 'not_a_timestamp'  # Text that can't be cast
    else:
        event_time_str = event_time.strftime('%Y-%m-%d %H:%M:%S')
    
    event = {
        'user_id': user_id,
        'event_type': event_type,
        'event_time': event_time_str
    }
    events.append(event)
    
    # 2% duplicate events (replay/retry scenario - no event_id makes this realistic)
    # Randomly duplicate a previous event to simulate replay/retry
    if random.random() < DUPLICATE_EVENT_RATE and len(events) > 1:
        issue_counts['duplicate_events'] += 1
        # Duplicate a random previous event (simulates replay)
        duplicate_event = random.choice(events[:-1])  # Exclude the event we just added
        events.append(duplicate_event.copy())

# Write CSV files (overwrite originals)
print("Writing CSV files...")
with open('fintech_plg/seeds/users.csv', 'w', newline='') as f:
    writer = csv.DictWriter(f, fieldnames=['user_id', 'signup_date', 'plan_type'])
    writer.writeheader()
    writer.writerows(users)

with open('fintech_plg/seeds/transactions.csv', 'w', newline='') as f:
    writer = csv.DictWriter(f, fieldnames=['transaction_id', 'user_id', 'amount', 'timestamp'])
    writer.writeheader()
    writer.writerows(transactions)

with open('fintech_plg/seeds/events.csv', 'w', newline='') as f:
    writer = csv.DictWriter(f, fieldnames=['user_id', 'event_type', 'event_time'])
    writer.writeheader()
    writer.writerows(events)

# Print actual counts
print(f"\nGenerated {len(users)} users (including {issue_counts['duplicate_user_ids']} duplicates)")
print(f"Generated {len(transactions)} transactions ({issue_counts['orphan_transactions']} orphan)")
print(f"Generated {len(events)} events ({issue_counts['late_arriving_events']} late-arriving)")
print("Actual data quality issues introduced:")
print(f"  - {issue_counts['whitespace_user_ids']} user_ids with whitespace (in users table)")
print(f"  - {issue_counts['duplicate_user_ids']} duplicate user_ids")
print(f"  - {issue_counts['inconsistent_casing']} users with inconsistent plan_type casing")
print(f"  - {issue_counts['orphan_transactions']} orphan transactions (missing users)")
print(f"  - {issue_counts['malformed_timestamps']} malformed timestamps (will fail cast)")
print(f"  - {issue_counts['late_arriving_events']} late-arriving events")
print(f"  - {issue_counts['duplicate_transaction_ids']} duplicate transaction_ids")
print(f"  - {issue_counts['duplicate_events']} duplicate events (no event_id - dedupe by user_id+event_type+event_time)")
print(f"  - {issue_counts['dirty_id_references']} transactions/events referencing dirty user_ids")

