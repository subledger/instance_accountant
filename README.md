Subledger instance accountant Ruby gem

Installation:

    gem install instance_accountant

Gemfile:

    gem 'instance_accountant'

The gem provides an executable that can be invoked two ways:

1) you want to account for the hourly cost of instances:

    #!/bin/bash

    instance_accountant account                                          \
      --cost              0.1                                            \
      --cost_reference    'http://test.com/cost'                         \
      --expense_acct      subledger_account_id                           \
      --payable_acct      subledger_account_id                           \
      --key_id            subledger_key_id                               \
      --secret            subledger_secret                               \
      --org_id            subledger_org_id                               \
      --book_id           subledger_book_id                              \
      --daemon 2>&1 >> instance_accountant.log

2) you want to account for both the hourly cost and income:

    #!/bin/bash

    instance_accountant account                                          \
      --cost              0.1                                            \
      --expense_acct      subledger_account_id                           \
      --payable_acct      subledger_account_id                           \
      --price             0.2                                            \
      --receivable_acct   subledger_account_id                           \
      --income_acct       subledger_account_id                           \
      --key_id            subledger_key_id                               \
      --secret            subledger_secret                               \
      --org_id            subledger_org_id                               \
      --book_id           subledger_book_id                              \
      --daemon 2>&1 >> instance_accountant.log

Here's a complete set of options:

    Options:
      f, [--filepath=FILEPATH]
                                                   # Default: ~/.instance_accountant
      d, --description=DESCRIPTION
                                                   # Default: instance usage for: %
          [--reference=REFERENCE]
      c, --cost=COST
          [--cost-description=COST_DESCRIPTION]
                                                   # Default: instance cost for: %
          [--cost-reference=COST_REFERENCE]
      e, --expense-acct=EXPENSE_ACCT
      p, --payable-acct=PAYABLE_ACCT
      p, [--price=PRICE]
          [--price-description=PRICE_DESCRIPTION]
                                                   # Default: instance price for %
          [--price-reference=PRICE_REFERENCE]
      i, [--income-acct=INCOME_ACCT]
      r, [--receivable-acct=RECEIVABLE_ACCT]
      k, --key-id=KEY_ID
      s, --secret=SECRET
      o, --org-id=ORG_ID
      b, --book-id=BOOK_ID
          [--daemon], [--no-daemon]

Note: %s in descriptions will be replaced by the ISO 8601 of the hour in UTC
Note: instance_accountant captures errors and does its best to keep running
