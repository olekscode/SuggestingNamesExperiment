Class {
	#name : #NGModel,
	#superclass : #Object,
	#instVars : [
		'ngramModel',
		'tfidfModel',
		'tfidfThreshold'
	],
	#category : #SuggestingNamesExperiment
}

{ #category : #'as yet unclassified' }
NGModel >> chooseKeywordsFrom: codeAsCollectionOfWords [
	| tfidfScores keywords maxScore |
	tfidfScores := codeAsCollectionOfWords asSet
		select: [ :word | tfidfModel vocabulary includes: word ]
		thenCollect: [ :word |
			word -> (tfidfModel scoreOf: word in: codeAsCollectionOfWords) ].
		
	tfidfScores ifEmpty: [ 
		^ { codeAsCollectionOfWords asSet anyOne } ].
	
	keywords := (tfidfScores select: [ :each | each value > self tfidfThreshold ]) asDataSeries sortDescending keys.
	
	keywords ifEmpty: [ 
		maxScore := tfidfScores asDictionary max.
		keywords := { (tfidfScores detect: [ :assoc | assoc value = maxScore ]) key } ].
	
	keywords size > 5 ifTrue: [ 
		keywords := keywords first: 5 ].
	
	^ keywords
]

{ #category : #accessing }
NGModel >> defaultTfidfThreshold [
	 ^2.5
]

{ #category : #training }
NGModel >> initialize [ 
	| ngramSmoothing |
	super initialize.
	tfidfModel := TermFrequencyInverseDocumentFrequency new.
	tfidfThreshold := self defaultTfidfThreshold.
	
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
	
	aCollectionOfWords
		ifEmpty: [ ^ aCollectionOfWords ].
	
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
	"orderedKeywords := self orderWords: keywords.
	^ orderedKeywords "
	^ keywords
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

{ #category : #accessing }
NGModel >> tfidfModel [
	^tfidfModel
]

{ #category : #accessing }
NGModel >> tfidfThreshold [
	^tfidfThreshold
]

{ #category : #accessing }
NGModel >> tfidfThreshold: anObject [
	tfidfThreshold := anObject
]

{ #category : #training }
NGModel >> trainOn: trainMethodsTable [
	| sources names |
	sources := (trainMethodsTable column: 'source') asOrderedCollection.
	names := (trainMethodsTable column: 'name') asOrderedCollection.
	
	tfidfModel trainOn: sources.
	ngramModel trainOnMethods: names.
]
