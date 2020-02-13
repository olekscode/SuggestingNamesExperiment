Class {
	#name : #NGDatasetBuilder,
	#superclass : #Object,
	#instVars : [
		'dataDirectory'
	],
	#category : #SuggestingNamesExperiment
}

{ #category : #'private - loading data' }
NGDatasetBuilder >> dataDirectory [
	^ dataDirectory 
]

{ #category : #'private - loading data' }
NGDatasetBuilder >> dataDirectory: anObject [
	dataDirectory := anObject
]

{ #category : #'private - loading data' }
NGDatasetBuilder >> loadMethodsTableFrom: aFileReference [
	| methods |
	methods := DataFrame readFromCsv: aFileReference withSeparator: Character tab.
	self splitNamesIn: methods.
	self splitNamesSourcesIn: methods.
	^ methods.
]

{ #category : #'private - loading data' }
NGDatasetBuilder >> loadTestMethodsTable [
	^ self loadMethodsTableFrom: self testMethodsTableFile
]

{ #category : #'private - loading data' }
NGDatasetBuilder >> loadTrainMethodsTable [
	^ self loadMethodsTableFrom: self trainMethodsTableFile
]

{ #category : #'private - loading data' }
NGDatasetBuilder >> loadValidMethodsTable [
	^ self loadMethodsTableFrom: self validMethodsTableFile
]

{ #category : #'private - loading data' }
NGDatasetBuilder >> splitNamesIn: methodsTable [
	"This method will be removed"
	| splitCamelcase makeLowercase removeNonAlphabetic joinWithSpaces preprocessName |
	splitCamelcase := [ :name | name splitIdentifierName ].

	makeLowercase := [ :tokens | 
		tokens collect: [ :each | each asLowercase ] ].

	removeNonAlphabetic := [ :tokens |
		tokens select: [ :each | each allSatisfy: #isLetter ] ].

	joinWithSpaces := [ :tokens | ' ' join: tokens ].

	preprocessName :=  [ :name |
		| tokens |
		tokens := splitCamelcase value: name.
		tokens := makeLowercase value: tokens.
		tokens := removeNonAlphabetic value: tokens.
		joinWithSpaces value: tokens ].

	methodsTable 
		toColumn: 'name'
		applyElementwise: [ :each | preprocessName value: each ].
]

{ #category : #'private - loading data' }
NGDatasetBuilder >> splitNamesSourcesIn: methodsTable [
	methodsTable 
		toColumns: #(name source)
		applyElementwise: [ :each | each substrings ].
]

{ #category : #'private - loading data' }
NGDatasetBuilder >> testMethodsTableFile [
	^ self dataDirectory / 'test_methods.csv'.
]

{ #category : #'private - loading data' }
NGDatasetBuilder >> trainMethodsTableFile [
	^ self dataDirectory / 'train_methods.csv'.
]

{ #category : #'private - loading data' }
NGDatasetBuilder >> validMethodsTableFile [
	^ self dataDirectory / 'valid_methods.csv'.
]
