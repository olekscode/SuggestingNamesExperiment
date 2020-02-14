Class {
	#name : #NGModel,
	#superclass : #Object,
	#instVars : [
		'ngramModel',
		'tfidfModel'
	],
	#category : #SuggestingNamesExperiment
}

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
NGModel >> suggestNameFor: codeAsCollectionOfWords [
	| tfidfScores |
	tfidfScores := codeAsCollectionOfWords asSet
		select: [ :word | tfidfModel vocabulary includes: word ]
		thenCollect: [ :word |
			word -> (tfidfModel scoreOf: word in: codeAsCollectionOfWords) ].
	
	^ tfidfScores select: [ :each | each value > 4 ] thenCollect: [ :each | each key ]
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
