Class {
	#name : #NGModel,
	#superclass : #Object,
	#instVars : [
		'tfidf',
		'ngramModel'
	],
	#category : #SuggestingNamesExperiment
}

{ #category : #training }
NGModel >> initialize [ 
	| ngramSmoothing |
	super initialize.
	tfidf := PGTermFrequencyInverseDocumentFrequency new.
	
	ngramSmoothing := NgramLaplaceSmoothing new.
	ngramModel := NgramModel order: 2 withSmoothing: ngramSmoothing.
]

{ #category : #training }
NGModel >> trainOn: trainMethodsTable [
	| sources |
	sources := (trainMethodsTable column: 'source') asOrderedCollection.
	tfidf trainOn: sources.
	ngramModel trainOnMethods: sources.
]
