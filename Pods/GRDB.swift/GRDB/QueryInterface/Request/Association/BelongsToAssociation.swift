/// Thes `BelongsToAssociation` sets up a one-to-one connection from a record
/// type to another record type, such as each instance of the declaring record
/// "belongs to" an instance of the other record.
///
/// For example, if your application includes authors and books, and each book
/// is assigned its author, you'd declare the association this way:
///
/// ```swift
/// struct Author: TableRecord { }
/// struct Book: TableRecord {
///     static let author = belongsTo(Author.self)
/// }
/// ```
///
/// A `BelongsToAssociation` should be supported by an SQLite foreign key.
///
/// Foreign keys are the recommended way to declare relationships between
/// database tables because not only will SQLite guarantee the integrity of your
/// data, but GRDB will be able to use those foreign keys to automatically
/// configure your associations.
///
/// You define the foreign key when you create database tables. For example:
///
/// ```swift
/// try db.create(table: "author") { t in
///     t.autoIncrementedPrimaryKey("id")             // (1)
///     t.column("name", .text)
/// }
/// try db.create(table: "book") { t in
///     t.autoIncrementedPrimaryKey("id")
///     t.belongsTo("author", onDelete: .cascade)     // (2)
///         .notNull()                                // (3)
///     t.column("title", .text)
/// }
/// ```
///
/// 1. The author table has a primary key.
/// 2. The `book.authorId` column is used to link a book to the author it
///    belongs to. This column is indexed in order to ease the selection of
///    an author's books. A foreign key is defined from `book.authorId`
///    column to `authors.id`, so that SQLite guarantees that no book refers
///    to a missing author. The `onDelete: .cascade` option has SQLite
///    automatically delete all of an author's books when that author is
///    deleted. See <https://sqlite.org/foreignkeys.html#fk_actions> for
///    more information.
/// 3. Make the `book.authorId` column not null if you want SQLite to guarantee
///    that all books have an author.
///
/// The example above uses auto-incremented primary keys. But generally
/// speaking, all primary keys are supported.
///
/// If the database schema does not define foreign keys between tables, you can
/// still use `BelongsToAssociation`. But your help is needed to define the
/// missing foreign key:
///
/// ```swift
/// struct Book: TableRecord {
///     static let author = belongsTo(Author.self, using: ForeignKey(...))
/// }
/// ```
public struct BelongsToAssociation<Origin, Destination> {
    public var _sqlAssociation: _SQLAssociation
    
    init(
        to destinationRelation: SQLRelation,
        key: String?,
        using foreignKey: ForeignKey?)
    {
        let destinationTable = destinationRelation.source.tableName
        
        let foreignKeyCondition = SQLForeignKeyCondition(
            destinationTable: destinationTable,
            foreignKey: foreignKey,
            originIsLeft: true)
        
        let associationKey: SQLAssociationKey
        if let key {
            associationKey = .fixedSingular(key)
        } else {
            associationKey = .inflected(destinationTable)
        }
        
        _sqlAssociation = _SQLAssociation(
            key: associationKey,
            condition: .foreignKey(foreignKeyCondition),
            relation: destinationRelation,
            cardinality: .toOne)
    }
}

extension BelongsToAssociation: AssociationToOne {
    public typealias OriginRowDecoder = Origin
    public typealias RowDecoder = Destination
}
