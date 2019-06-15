# SimFin

## App idea

To provide funds availible taking into consideration future expenses and transfers

## Mechanics

The app work based on system comprised of:
1. Accounts
2. Transactions
3. Rules

Accounts - is aggregation of financial info of certain type, e.g. Account "Wallet" has the info about transfers from and to wallet, Account "Morgage" has the info about mortgage transactions. Account types are the following:
- Assets
- Expenses
- Liablilites
- Revenues
- Capital - balancing account which corresponds to "wealth"


Transaction is a transfer from one Account to another. For example purchase of a book could be reflected as a Transaction from "Wallet" (Asset) to "Education" (Expenses).

Rule is definition of what transaction should happen in the future.

Based on that we could get Forecast of certain account or group of accounts and 

## App Data Model

### Rules

#### Rule attributes

1. from - account from which transfer
2. to - account to which transfer
3. amount - amount of the transaction
4. baseAccount - account, which value to use to calculate transaction amount
5. ratio - multiplier to base account amount to get a transaction value
6. period - how often to execute (daily, weekly, monthly, etc)
7. end - data / time to stop execution
8. lastExcuted - data / time

#### Rule mechanics

When initializing the app we register listners so get the updates about rules, when we initializing instance of the rules 