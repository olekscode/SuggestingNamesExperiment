Class {
	#name : #NGModel,
	#superclass : #Object,
	#category : #SuggestingNamesExperiment
}

{ #category : #'as yet unclassified' }
NGModel >> suggestNameFor: codeAsCollectionOfWords [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
NGModel >> suggestNameForMethod: aCompiledMethod [
	| sourceCodeWords nameWords |
	sourceCodeWords := aCompiledMethod wordsFromIdentifierNames.
	nameWords := self suggestNameFor: sourceCodeWords.
	^ (' ' join: nameWords) asCamelCase uncapitalized.
]

{ #category : #'as yet unclassified' }
NGModel >> suggestNamesForAll: aCollectionOfMethodWords [
	| names |
	names := OrderedCollection new.
	
	(1 to: aCollectionOfMethodWords size)
		do: [ :i | names add: (self suggestNameFor: (aCollectionOfMethodWords at: i)) ]
		displayingProgress: [ :i | 'Generating name for method ', i asString, ' (', (i / aCollectionOfMethodWords size * 100 asFloat round: 2) asString, '%)' ].
		
	^ names
]
