# Database Schema Migration

## Overview
The database schema has been updated to match the Android diary app structure, allowing you to directly import SQLite database files from the Android app.

## New Database Structure

### Tables

#### 1. android_metadata
- **locale** (TEXT) - Stores locale information (default: 'en_US')

#### 2. diary
- **date** (TEXT NOT NULL, PRIMARY KEY) - Date in YYYY-MM-DD format
- **year** (INTEGER NOT NULL) - Year component
- **month** (INTEGER NOT NULL) - Month component (1-12)
- **day** (INTEGER NOT NULL) - Day component
- **content** (TEXT NOT NULL) - Markdown content of the diary entry
- **created** (TEXT NOT NULL) - ISO8601 timestamp when entry was created
- **updated** (TEXT) - ISO8601 timestamp when entry was last updated

#### Index
- **diary_idx_0** on (year, month) - For efficient querying by year/month

## Changes from Previous Version

### Old Schema
- Table: `journal_entries`
- Columns: `id` (UUID), `date`, `timestamp`, `markdown_content`
- Multiple entries per day possible (UUID-based)

### New Schema
- Table: `diary`
- Columns: `date` (primary key), `year`, `month`, `day`, `content`, `created`, `updated`
- One entry per day (date-based primary key)

## Key Differences

1. **Primary Key**: Changed from UUID to date string (YYYY-MM-DD)
2. **Date Components**: Added separate year, month, day integer columns for efficient filtering
3. **Timestamps**: Simplified to created/updated strings instead of separate date/timestamp objects
4. **Android Compatibility**: Added android_metadata table for full Android diary app compatibility

## Importing Android Diary Database

To import your Android diary database:

1. **Option 1: Direct File Import**
   - Copy your Android `.db` file to the DigitalGram storage folder
   - In Settings → Database Management, select the database from the dropdown

2. **Option 2: Database Import Feature**
   - In Settings → Data Management, click "Import Database"
   - Select your Android diary `.db` file
   - It will be copied to the storage location

## Export/Import Format

### CSV Format
```
Date,Content,Created,Updated
2026-01-12,"Entry content here","2026-01-12T19:00:00Z","2026-01-12T19:30:00Z"
```

### Excel Format
- Sheet Name: "Diary"
- Columns: Date, Content, Created, Updated

## Notes

- All existing data will be preserved during upgrades
- New databases created will automatically use the new schema
- The app handles the date-based primary key automatically
- One entry per day is enforced by the database structure
- Timestamps are stored in ISO8601 format for maximum compatibility
