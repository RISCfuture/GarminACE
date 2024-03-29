# GarminACE

GarminACE is a Swift package that parses `.ace` files generated by the Garmin Aviation
Checklist Editor.

## Installation

GarminACE is a Swift Package Manager project. Simply add this repository as a
dependency in your project.

## Usage

Import a `.ace` file using `ACEFileDecoder`:

``` swift
import GarminACE

let data = Data(contentsOf: myFileURL)
let checkistSet = ACEFileDecoder().new(data)
```
See the `ChecklistFile` documentation to learn about the model schema.

A `ChecklistFile` can be written back to an `.ace` file using
`ACEFileEncoder`:

``` swift
ACEFileEncoder(checklistSet: checklists).write(to: fileURL)
```

`ChecklistFile` is also `Codable` and `Decodable`, so you could re-save the
checklist in a more palatable format like JSON:

``` swift
let jsonData = try JSONEncoder().encode(checklistSet)
let decodedChecklistSet = try JSONDecoder().decode(ChecklistFile.self, from: data)
```

## Documentation

Online API documentation and tutorials are available at
https://riscfuture.github.io/GarminACE/documentation/garminace/

DocC documentation is available, including tutorials and API documentation. For
Xcode documentation, you can run

```sh
swift package generate-documentation --target GarminACE
```

to generate a docarchive at
`.build/plugins/Swift-DocC/outputs/GarminACE.doccarchive`. You can open this
docarchive file in Xcode for browseable API documentation. Or, within Xcode,
open the GarminACE package in Xcode and choose **Build Documentation** from the
**Product** menu.

## Developing

This package contains a short test suite written using Nimble and Quick. Use `swift test`
to run the suite.
