Class {
	#name : #NGEvaluator,
	#superclass : #Object,
	#category : #SuggestingNamesExperiment
}

{ #category : #'as yet unclassified' }
NGEvaluator >> allScoresOf: predictedValues withTrueValues: trueValues [
	| scores |
	
	scores := { 
		'ExactMatch' -> (self exactMatchScoreOf: predictedValues withTrueValues: trueValues) .
		'Precision' -> (self averagePrecisionScoreOf: predictedValues withTrueValues: trueValues) .
		'Recall' -> (self averageRecallScoreOf: predictedValues withTrueValues: trueValues) .
		'F1' -> (self averageF1ScoreOf: predictedValues withTrueValues: trueValues) .
	} asDictionary.
	
	^ scores collect: [ :each | (each asFloat * 100 round: 1) asString, '%' ]
]

{ #category : #'as yet unclassified' }
NGEvaluator >> averageF1ScoreOf: predictedValues withTrueValues: trueValues [
	| f1Sum |
	
	f1Sum := (1 to: predictedValues size) inject: 0 into: [ :sum :i |
		sum + (self f1ScoreOf: (predictedValues at: i) withTrueValues: (trueValues at: i)) ].
		
	^ f1Sum / predictedValues size
]

{ #category : #'as yet unclassified' }
NGEvaluator >> averagePrecisionScoreOf: predictedValues withTrueValues: trueValues [
	| precisionSum |
	
	precisionSum := (1 to: predictedValues size) inject: 0 into: [ :sum :i |
		sum + (self precisionScoreOf: (predictedValues at: i) withTrueValues: (trueValues at: i)) ].
		
	^ precisionSum / predictedValues size
]

{ #category : #'as yet unclassified' }
NGEvaluator >> averageRecallScoreOf: predictedValues withTrueValues: trueValues [
	| recallSum |
	
	recallSum := (1 to: predictedValues size) inject: 0 into: [ :sum :i |
		sum + (self recallScoreOf: (predictedValues at: i) withTrueValues: (trueValues at: i)) ].
		
	^ recallSum / predictedValues size
]

{ #category : #'as yet unclassified' }
NGEvaluator >> exactMatchScoreOf: predictedValues withTrueValues: trueValues [
	| numberOfExactMatches |
	
	numberOfExactMatches := (1 to: predictedValues size) inject: 0 into: [ :sum :i |
		(predictedValues at: i) = (trueValues at: i)
			ifTrue: [ sum + 1 ]
			ifFalse: [ sum ] ].
		
	^ numberOfExactMatches / predictedValues size
]

{ #category : #'as yet unclassified' }
NGEvaluator >> f1ScoreOf: candidate withTrueValues: reference [
	| precision recall |
	
	precision := self precisionScoreOf: candidate withTrueValues: reference.
	recall := self recallScoreOf: candidate withTrueValues: reference.
	
	(precision = 0 or: recall = 0)
		ifTrue: [ ^ 0 ].
	
	^ 2 * precision * recall / (precision + recall)
]

{ #category : #'as yet unclassified' }
NGEvaluator >> precisionScoreOf: candidate withTrueValues: reference [
	| numberOfTruePositives numberOfPredictedPositives |
	
	(candidate isEmpty or: reference isEmpty)
		ifTrue: [ ^ 0 ].
		
	numberOfTruePositives := (candidate asSet intersection: reference asSet) size.
	numberOfPredictedPositives := candidate asSet size.
	
	^ numberOfTruePositives / numberOfPredictedPositives
]

{ #category : #'as yet unclassified' }
NGEvaluator >> recallScoreOf: candidate withTrueValues: reference [
	| numberOfTruePositives numberOfPositives |
	
	(candidate isEmpty or: reference isEmpty)
		ifTrue: [ ^ 0 ].
		
	numberOfTruePositives := (candidate asSet intersection: reference asSet) size.
	numberOfPositives := reference asSet size.
	
	^ numberOfTruePositives / numberOfPositives
]
