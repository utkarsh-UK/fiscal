Map<String, Object?> transactionQuery = {
  "transaction_id": "id",
  "date": "2021-05-14T14:13:29.104",
  "title": "title",
  "description": "desc",
  "amount": 10.10,
  "transaction_type": "INCOME",
  "category_id": 1,
  "account_id": 1,
  "acc_id": 1,
  "icon": 'icon',
  'color': 'color',
  'bank_name': 'bank',
  'account_no': 12345,
};

Map<String, Object?> categoryQuery = {
  "category_id": 1,
  "created_at": "2021-05-14T14:13:29.104",
  "name": "category",
  "icon": "category",
  "color": 'color',
  "transaction_type": "EXPENSE",
};

Map<String, Object?> accountQuery = {
  "account_id": 1,
  "account_no": 12345,
  "bank_name": 'bank',
  "balance": 10000.0,
  "logo": 'logo',
  "timestamp": "2021-05-14T14:13:29.104",
  "account_type": "SAVINGS",
};
