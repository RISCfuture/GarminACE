# ``GarminACE``

A Swift package that parses `.ace` files generated by the Garmin Aviation
Checklist Editor.

## Overview

GarminACE is a Swift package that parses `.ace` files generated by the Garmin
Aviation Checklist Editor.

**Important Note:** Only importing is supported for now. Preliminary export code
exists, but it's not complete, because I don't yet understand the format of the
binary data at the tail end of the ACE file.

To import a `.ace` file:

``` swift
import GarminACE

let data = Data(contentsOf: myFileURL)
let checkistSet = ACEFileDecoder().new(data)
```
See the ``ChecklistFile`` documentation to learn about the model schema.

``ChecklistFile`` is also `Codable` and `Decodable`, so you could re-save the
checklist in a more palatable format like JSON:

``` swift
let jsonData = try JSONEncoder().encode(checklistSet)
let decodedChecklistSet = try JSONDecoder().decode(ChecklistFile.self, from: data)
```

## Topics

### Checklists

- ``ChecklistFile``
- ``ChecklistGroup``
- ``Checklist``
- ``Checklist/Item``
- ``Indent``

### Encoding

- ``ACEFileDecoder``

### Decoding

- ``ACEFileEncoder``

### Errors

- ``DecoderError``
- ``EncoderError``
- ``CodingError``