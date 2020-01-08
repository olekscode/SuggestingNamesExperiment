Class {
	#name : #SuggestingNamesExperiment,
	#superclass : #Object,
	#instVars : [
		'methodsTable'
	],
	#category : #SuggestingNamesExperiment
}

{ #category : #private }
SuggestingNamesExperiment >> constructMethodsTableFromMetadata: methodsMetadataTable andWords: wordsTable [
	| methodsTable |
	methodsTable := methodsMetadataTable columns: #(id project class selector).
	methodsTable addColumn: (wordsTable column: 'words').
	^ methodsTable
	
]

{ #category : #public }
SuggestingNamesExperiment >> loadData [
	| methodsMetadataTable wordsTable |
	
	methodsMetadataTable := self loadMethodsMetadataTable.
	wordsTable := self loadWordsTable.
	methodsTable := self constructMethodsTableFromMetadata: methodsMetadataTable andWords: wordsTable.
	
	self splitWords.
]

{ #category : #private }
SuggestingNamesExperiment >> loadMethodsMetadataTable [
	^ DataFrame readFromCsv: self pathToMethodsMetadataTableFile.
]

{ #category : #private }
SuggestingNamesExperiment >> loadWordsTable [
	^ DataFrame readFromCsv: self pathToWordsTableFile.
]

{ #category : #private }
SuggestingNamesExperiment >> pathToDataDirectory [
	^ '/Users/oleks/Documents/Research/2019-sourcecodedata/data' asFileReference
]

{ #category : #private }
SuggestingNamesExperiment >> pathToMethodsMetadataTableFile [
	^ self pathToDataDirectory / 'methods.csv'.
]

{ #category : #private }
SuggestingNamesExperiment >> pathToWordsTableFile [
	^ self pathToDataDirectory / 'words.csv'.
]

{ #category : #private }
SuggestingNamesExperiment >> splitWords [
	methodsTable toColumn: 'words' applyElementwise: [ :words |
		words
			ifNil: [ OrderedCollection new ]
			ifNotNil: [ ' ' split: words ] ].
]
