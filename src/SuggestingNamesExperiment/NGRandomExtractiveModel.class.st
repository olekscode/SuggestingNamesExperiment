Class {
	#name : #NGRandomExtractiveModel,
	#superclass : #NGRandomModel,
	#category : #SuggestingNamesExperiment
}

{ #category : #'as yet unclassified' }
NGRandomExtractiveModel >> suggestNameFor: codeAsCollectionOfWords [
	| uniqueWordsFromSourceCode |
	uniqueWordsFromSourceCode := codeAsCollectionOfWords asSet.
	^ self randomNameFromVocabulary: uniqueWordsFromSourceCode
]
