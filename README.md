# AccountsCoreDataManagement

## Overview

This package implements the protocols from [DataManagement](https://github.com/bastianX6/accounts-data-management) package using `CoreData` as Data Source.

- `CoreDataSourceModify` class implements the `DataSourceModify` protocol.
- `CoreDataSourceRead` class implements the `DataSourceModify` protocol.

## Persistence Controller

The `PersistenceController` is a singleton that manages the `CoreData` persistent container initialization. It uses a `NSPersistentCloudKitContainer` instance.
