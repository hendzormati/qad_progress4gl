# QAD Progress 4GL Item Management Tools

A collection of Progress 4GL programs for managing items in a QAD database, featuring interactive item addition, CSV import/export capabilities, and data validation.

## Programs Overview

### 1. zzadditem.p - Interactive Item Addition
Program for adding new items to the database through user input with real-time validation.

#### Features
- Interactive form-based input
- Real-time data validation
- Domain-specific item creation (POLYMED domain)
- Comprehensive field validation:
  - Item Number uniqueness
  - Product Line existence
  - Item Type validation
  - Status verification
  - Purchase/Manufacture code validation

#### Required Fields
- Item Number
- Description (default: "new item added from putty")
- Prod Line (default: "Def")
- Added Date (default: today)
- Item Type (default: "BB")
- Status (default: "ACTIF")
- Purchase/Manufacture (default: "P")
- Price (default: 0)

### 2. xxadditem.p - CSV-Based Item Import
Program for bulk importing items from a CSV file with validation.

#### Features
- CSV file import functionality
- Automatic data validation
- Bulk item creation
- Error handling and validation:
  - Directory and file accessibility checks
  - Data completeness verification
  - Business rule validation

#### CSV Format
Input file should be named `inputItem.csv` by default with fields separated by `|`:
```
domainItem|numItem|descItem|prodLine|addedDate|typeItem|statusItem|pur_manItem|priceItem
```

### 3. zzitemrange.p - Item Range Export
Program for exporting item details to CSV based on a specified item range.

#### Features
- Item range selection
- Cost calculation integration
- CSV export with timestamp
- Directory validation
- Tabular data display

#### Export Format
Generated CSV includes:
- Item Number
- Description
- Item Price
- Cost Standard
- Cost Current

Output filename format: `itemDetailsTable_DDMMYYYY_HHMMSS.csv`

## Prerequisites

- QAD EE environment
- Progress 4GL runtime
- Appropriate database permissions
- Access to the following database tables:
  - pt_mstr
  - pl_mstr
  - code_mstr
  - qad_wkfl
  - sct_det
  - sct_cst_tot

## Usage

### Adding Single Items
```progress
RUN zzadditem.p
```
Follow the interactive form to input item details.

### Importing Items from CSV
```progress
RUN xxadditem.p
```
Ensure your CSV file is properly formatted and accessible.

### Exporting Item Range
```progress
RUN zzitemrange.p
```
1. Enter starting and ending item numbers
2. Specify export directory
3. Review displayed data
4. Confirm export

## Data Validation Rules

### Item Addition Validation
- Item Number must be unique
- Product Line must exist in pl_mstr
- Item Type must exist in code_mstr
- Status must exist in qad_wkfl
- Purchase/Manufacture code must be valid

### CSV Import Validation
- All required fields must be present
- Item must not already exist
- Referenced values must exist in respective master tables
- Directory and file permissions are verified

## Error Handling

All programs include comprehensive error handling for:
- File access issues
- Data validation failures
- Database constraints
- Missing required fields
- Invalid reference data

## Directory Structure
```
.
├── README.md
├── zzadditem.p    # Interactive item addition
├── xxadditem.p    # CSV import functionality
└── zzitemrange.p  # Item range export
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request
