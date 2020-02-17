Class {
	#name : #NGRandomModel,
	#superclass : #NGModel,
	#category : #SuggestingNamesExperiment
}

{ #category : #'as yet unclassified' }
NGRandomModel >> defaultNumberOfWordsInMethodName [
	^3
]

{ #category : #'as yet unclassified' }
NGRandomModel >> randomNameFromVocabulary: aVocabulary [
	| indices |
	indices := (1 to: aVocabulary size) shuffled first: (self defaultNumberOfWordsInMethodName min: aVocabulary size).
	^ indices collect: [ :i | aVocabulary asOrderedCollection at: i ]
]
