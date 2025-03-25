import Foundation

/**
 A collection of ``ChecklistGroup``s that appear together in a `.ace` file.
 
 This class implements `Codable`, so you can re-export checklists in a more
 universal format (such as JSON).
 */
public final class ChecklistFile: Codable {

    /// The title of the checklist file (from the metadata, not the filename).
    public var name: String

    /// The aircraft make and model from the checklist file metadata.
    public var makeAndModel: String

    /// The aircraft info from the checklist file metadata.
    public var aircraftInfo: String

    /// The aircraft manufacturer ID from the checklist file metadata.
    public var manufacturerID: String

    /// The copyright string from the checklist file metadata.
    public var copyright: String

    /// The checklist groups in this file.
    public var groups: [ChecklistGroup]

    init(name: String, makeAndModel: String, aircraftInfo: String, manufacturerID: String, copyright: String) {
        self.name = name
        self.makeAndModel = makeAndModel
        self.aircraftInfo = aircraftInfo
        self.manufacturerID = manufacturerID
        self.copyright = copyright

        self.groups = []
    }
}

/// A group of ``Checklist``s, such as "Normal Procedures" or
/// "Supplemental Procedures".
public final class ChecklistGroup: Codable {

    /// The title of the group.
    public var name: String

    /// The indent level of the group.
    public var indent: Indent

    /// The checklists in this group.
    public var checklists: [Checklist]

    init(name: String, indent: Indent) {
        self.name = name
        self.indent = indent

        self.checklists = []
    }
}

/// A single checklist, consisting of multiple ``Item``s.
public final class Checklist: Codable {

    /// The checklist title.
    public var name: String

    /// The checklist's indent level.
    public var indent: Indent

    /// The items making up this checklist.
    public var items: [Item]

    init(name: String, indent: Indent) {
        self.name = name
        self.indent = indent

        self.items = []
    }

    /**
     An item in a checklist. Checklist items can be normal challenge-respose
     prompts, headers, notes of varying intensity levels, plaintext blocks, or
     blank lines.
     */

    public enum Item: Equatable {

        /**
         A header item.
         
         - Parameter text: The item text.
         - Parameter indent: The indent level.
         */
        case title(text: String, indent: Indent)

        /**
         A block of text presented at the warning (most critical) level.
         
         - Parameter text: The item text.
         - Parameter indent: The indent level.
         */
        case warning(text: String, indent: Indent)

        /**
         A block of text presented at the caution level.
         
         - Parameter text: The item text.
         - Parameter indent: The indent level.
         */
        case caution(text: String, indent: Indent)

        /**
         A block of text presented at the note (least critical) level.
         
         - Parameter text: The item text.
         - Parameter indent: The indent level.
         */
        case note(text: String, indent: Indent)

        /**
         An unformatted block of text.
         
         - Parameter text: The item text.
         - Parameter indent: The indent level.
         */
        case plaintext(text: String, indent: Indent)

        /**
         A challenge prompt and its response. Challenge/responses are the only
         checklist item that can be checked by the user.
         
         - Parameter challenge: The item challenge, such as "Flaps".
         - Parameter response: The challenge response, such as "DOWN".
         - Parameter indent: The indent level.
         */
        case challengeResponse(challenge: String, response: String, indent: Indent)

        /// A blank line, for spacing.
        case blank
    }
}

/**
 The indent level of a checklist group, checklist, or checklist item. Up to five
 indent levels are allowed (0 through 4), as well as an affordance for centered
 text.
 */
public enum Indent: Equatable {
    /**
     Text is indented _n_ levels deep from the left side.
     
     - Parameter level: The indent level.
     */
    case level(_ level: UInt)

    /// Text is centered.
    case centered
}
