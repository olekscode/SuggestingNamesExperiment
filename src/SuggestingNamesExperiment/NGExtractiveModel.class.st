Class {
	#name : #NGExtractiveModel,
	#superclass : #NGModel,
	#instVars : [
		'ngramModel',
		'tfidfModel',
		'tfidfThreshold'
	],
	#category : #SuggestingNamesExperiment
}

{ #category : #'as yet unclassified' }
NGExtractiveModel >> chooseKeywordsFrom: codeAsCollectionOfWords [
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
NGExtractiveModel >> defaultTfidfThreshold [
	 ^2.5
]

{ #category : #training }
NGExtractiveModel >> initialize [ 
	| ngramSmoothing |
	super initialize.
	tfidfModel := TermFrequencyInverseDocumentFrequency new.
	tfidfThreshold := self defaultTfidfThreshold.
	
	ngramSmoothing := NgramLaplaceSmoothing new.
	ngramModel := NgramModel order: 2 withSmoothing: ngramSmoothing.
]

{ #category : #accessing }
NGExtractiveModel >> ngramModel [
	^ngramModel
]

{ #category : #'as yet unclassified' }
NGExtractiveModel >> orderWords: aCollectionOfWords [
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
NGExtractiveModel >> suggestNameFor: codeAsCollectionOfWords [
	| keywords orderedKeywords |
	keywords := self chooseKeywordsFrom: codeAsCollectionOfWords.
	orderedKeywords := self orderWords: keywords.
	^ orderedKeywords
]

{ #category : #accessing }
NGExtractiveModel >> tfidfModel [
	^tfidfModel
]

{ #category : #accessing }
NGExtractiveModel >> tfidfThreshold [
	^tfidfThreshold
]

{ #category : #accessing }
NGExtractiveModel >> tfidfThreshold: anObject [
	tfidfThreshold := anObject
]

{ #category : #training }
NGExtractiveModel >> trainOn: trainMethodsTable [
	| sources names |
	sources := (trainMethodsTable column: 'source') asOrderedCollection.
	names := (trainMethodsTable column: 'name') asOrderedCollection.
	
	tfidfModel trainOn: sources.
	ngramModel trainOnMethods: names.
]
