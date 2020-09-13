# AccountsCoreDataManagement

[![Build Status](https://app.bitrise.io/app/4145e62976e741c9/status.svg?token=kE3wPI0fA7vKNU3m3yAlbg&branch=master)](https://app.bitrise.io/app/4145e62976e741c9)

## Overview

This package implements the protocols from [DataManagement](https://github.com/bastianX6/accounts-data-management) package using `CoreData` as Data Source.

- `CoreDataSourceModify` class implements the `DataSourceModify` protocol.
- `CoreDataSourceRead` class implements the `DataSourceModify` protocol.

## Persistence Controller

The `PersistenceController` is a singleton that manages the `CoreData` persistent container initialization. It uses a `NSPersistentCloudKitContainer` instance.

## Documentation
You can check documentation [here](https://bastianx6.github.io/accounts-coredata-management/)
