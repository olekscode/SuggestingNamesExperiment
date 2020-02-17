Class {
	#name : #NGRandomAbstractiveModel,
	#superclass : #NGRandomModel,
	#instVars : [
		'vocabulary'
	],
	#category : #SuggestingNamesExperiment
}

{ #category : #'as yet unclassified' }
NGRandomAbstractiveModel >> suggestNameFor: codeAsCollectionOfWords [
	^ self randomNameFromVocabulary: vocabulary
]

{ #category : #'as yet unclassified' }
NGRandomAbstractiveModel >> trainOnNames: aCollectionOfNames [
	vocabulary := (aCollectionOfNames flatCollect: #yourself) asSet
]
