# Lab Freezer Tracking:
### A lite RShiny app for managing your lab data

A simple RShiny app for tracking tubes and biospecimen lab data

## Installation & Setup

<place instructions here>

## Preparing Demo Database

Using SQLite3 for persistent data storage & management. [Tutorial](https://www.guru99.com/sqlite-database.html)

1. Install SQLite on your computer
2. From commandline: `sqlite3 data/labdata.db < setup_app_database.sql`
3. Validate db. Upon entering database check fields: `.schema patient`

`sqlite> .header on`
`sqlite> .mode column`
`sqlite> pragma table_info('patient');`