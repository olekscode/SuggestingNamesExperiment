Class {
	#name : #NGModel,
	#superclass : #Object,
	#instVars : [
		'ngramModel',
		'tfidfModel'
	],
	#category : #SuggestingNamesExperiment
}

{ #category : #'as yet unclassified' }
NGModel >> chooseKeywordsFrom: codeAsCollectionOfWords [
	| tfidfScores |
	tfidfScores := codeAsCollectionOfWords asSet
		select: [ :word | tfidfModel vocabulary includes: word ]
		thenCollect: [ :word |
			word -> (tfidfModel scoreOf: word in: codeAsCollectionOfWords) ].
	
	^ tfidfScores asDataSeries sortDescending keys first: (3 min: tfidfScores size)
	"^ (tfidfScores select: [ :each | each value > 4 ]) asDataSeries sortDescending keys"
]

{ #category : #training }
NGModel >> initialize [ 
	| ngramSmoothing |
	super initialize.
	tfidfModel := TermFrequencyInverseDocumentFrequency new.
	
	ngramSmoothing := NgramLaplaceSmoothing new.
	ngramModel := NgramModel order: 2 withSmoothing: ngramSmoothing.
]

{ #category : #accessing }
NGModel >> ngramModel [
	^ngramModel
]

{ #category : #'as yet unclassified' }
NGModel >> orderWords: aCollectionOfWords [
	| permutations scores |
	permutations := OrderedCollection new.
	
	aCollectionOfWords permutationsDo: [ :each | permutations add: each copy ].
	scores := permutations collect: [ :each | each -> (ngramModel probabilityOfSequence: each) ].
	scores := scores asDataSeries.
	^ scores keyAtValue: scores max

]

{ #category : #'as yet unclassified' }
NGModel >> suggestNameFor: codeAsCollectionOfWords [
	| keywords orderedKeywords |
	keywords := self chooseKeywordsFrom: codeAsCollectionOfWords.
	orderedKeywords := self orderWords: keywords.
	^ orderedKeywords 
]

{ #category : #'as yet unclassified' }
NGModel >> suggestNameForMethod: aCompiledMethod [
	| sourceCodeWords nameWords |
	sourceCodeWords := aCompiledMethod wordsFromIdentifierNames.
	nameWords := self suggestNameFor: sourceCodeWords.
	^ (' ' join: nameWords) asCamelCase uncapitalized.
]

{ #category : #accessing }
NGModel >> tfidfModel [
	^tfidfModel
]

{ #category : #training }
NGModel >> trainOn: trainMethodsTable [
	| sources |
	sources := (trainMethodsTable column: 'source') asOrderedCollection.
	tfidfModel trainOn: sources.
	ngramModel trainOnMethods: sources.
]
