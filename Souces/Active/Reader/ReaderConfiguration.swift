import Foundation

extension CSVReader {
    /// Specific configuration variables for the CSV reader.
    internal struct Configuration {
        /// The unicode scalar delimiters for fields and rows.
        let delimiters: CSV.Delimiter.RawPair
        /// Boolean indicating whether the received CSV contains a header row or not.
        let hasHeader: Bool
        /// The characters set to be trimmed at the beginning and ending of each field.
        let trimCharacters: CharacterSet?
        /// The unicode scalar used as encapsulator and escaping character (when printed two times).
        let escapingScalar: Unicode.Scalar = Unicode.Scalar.quote
        
        /// Designated initializer taking generic CSV configuration (with possible unknown data) and making it specific to a CSV reader instance and its iterator.
        /// - parameter config: Generic CSV file configuration variables.
        /// - parameter iterator: Source of the unicode scalar data. Note, that you can only iterate once through it.
        /// - parameter buffer: Buffer containing all read scalars used to infer not specified information.
        /// - throws: `CSVReader.Error` exclusively.
        init(configuration config: CSV.Configuration, iterator: AnyIterator<Unicode.Scalar>, buffer: Buffer) throws {
            switch config.trimStrategry {
            case .none: self.trimCharacters = nil
            case .whitespaces: self.trimCharacters = CharacterSet.whitespaces
            case .set(let set): self.trimCharacters = (!set.isEmpty) ? set : nil
            }
            
            let fieldDelimiter = config.delimiters.field.unicodeScalars
            let rowDelimiter = config.delimiters.row.unicodeScalars
            
            switch (fieldDelimiter, rowDelimiter) {
            case (let field?, let row?):
                try Configuration.validate(delimiter: field, identifier: "field")
                try Configuration.validate(delimiter: row, identifier: "row")
                self.delimiters = (field, row)
            case (nil, let row?):
                try Configuration.validate(delimiter: row, identifier: "row")
                self.delimiters = try CSVReader.inferFieldDelimiter(iterator: iterator, rowDelimiter: row, buffer: buffer)
            case (let field?, nil):
                try Configuration.validate(delimiter: field, identifier: "field")
                self.delimiters = try CSVReader.inferFieldDelimiter(iterator: iterator, rowDelimiter: field, buffer: buffer)
            case (nil, nil):
                self.delimiters = try CSVReader.inferDelimiters(iterator: iterator, buffer: buffer)
            }
            
            switch config.headerStrategy {
            case .none:
                self.hasHeader = false
            case .firstLine:
                self.hasHeader = true
            case .unknown:
                self.hasHeader = try CSVReader.inferHeaderStatus(iterator: iterator, buffer: buffer)
            }
        }
        
        /// Simple non-empty delimiter validation.
        /// - parameter delimiter: The unicode scalars that forms a given delimiter.
        /// - parameter identifier: String indicating whether the delimiter is a field or a row delimiter.
        /// - throws: `CSVReader.Error.invalidDelimiter` exclusively.
        private static func validate(delimiter: String.UnicodeScalarView, identifier: String) throws {
            guard !delimiter.isEmpty else {
                throw Error.invalidDelimiter(message: "Custom \(identifier) delimiters must include at least one unicode scalar.")
            }
        }
    }
}

extension CSVReader {
    /// Buffer used to stored previously read unicode scalars.
    internal final class Buffer: IteratorProtocol {
        /// Unicode scalars read inferring configuration variables that were unknown.
        ///
        /// This buffer is reversed to make it efficient to remove elements.
        private var readScalars: [Unicode.Scalar]
        
        /// Creates the buffer with a given capacity value.
        init(reservingCapacity capacity: Int = 10) {
            self.readScalars = []
            self.readScalars.reserveCapacity(capacity)
        }
        
        func next() -> Unicode.Scalar? {
            guard !self.readScalars.isEmpty else { return nil }
            return self.readScalars.removeLast()
        }
        
        /// Inserts a single unicode scalar at the beginning of the buffer.
        func preppend(scalar: Unicode.Scalar) {
            self.readScalars.append(scalar)
        }
        
        /// Inserts a sequence of scalars at the beginning of the buffer.
        func preppend<S:Sequence>(scalars: S) where S.Element == Unicode.Scalar {
            self.readScalars.append(contentsOf: scalars.reversed())
        }
        
        /// Appends a single unicode scalar to the buffer.
        func append(scalar: Unicode.Scalar) {
            self.readScalars.insert(scalar, at: self.readScalars.startIndex)
        }
        
        /// Appends a sequence of unicode scalars to the buffer.
        func append<S:Sequence>(scalars: S) where S.Element == Unicode.Scalar {
            self.readScalars.insert(contentsOf: scalars.reversed(), at: self.readScalars.startIndex)
        }
    }
}

extension CSVReader {
    /// Tries to infer the field delimiter given the row delimiter.
    /// - throws: `CSVReader.Error` exclusively.
    fileprivate static func inferFieldDelimiter(iterator: AnyIterator<Unicode.Scalar>, rowDelimiter: String.UnicodeScalarView, buffer: Buffer) throws -> CSV.Delimiter.RawPair {
        #warning("TODO:")
        fatalError()
    }
    
    /// Tries to infer the row delimiter given the field delimiter.
    /// - throws: `CSVReader.Error` exclusively.
    fileprivate static func inferRowDelimiter(iterator: AnyIterator<Unicode.Scalar>, fieldDelimiter: String.UnicodeScalarView, buffer: Buffer) throws -> CSV.Delimiter.RawPair {
        #warning("TODO:")
        fatalError()
    }
    
    /// Tries to infer both the field and row delimiter from the raw data.
    /// - throws: `CSVReader.Error` exclusively.
    fileprivate static func inferDelimiters(iterator: AnyIterator<Unicode.Scalar>, buffer: Buffer) throws -> CSV.Delimiter.RawPair {
        #warning("TODO:")
        fatalError()
    }
}

extension CSVReader {
    /// Tries to infer whether the CSV data has a header row or not.
    /// - throws: `CSVReader.Error` exclusively.
    fileprivate static func inferHeaderStatus(iterator: AnyIterator<Unicode.Scalar>, buffer: Buffer) throws -> Bool {
        #warning("TODO:")
        fatalError()
    }
}
