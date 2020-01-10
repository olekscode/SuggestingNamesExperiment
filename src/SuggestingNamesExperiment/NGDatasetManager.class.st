Class {
	#name : #NGDatasetManager,
	#superclass : #Object,
	#instVars : [
		'datasetBuilder',
		'datasetFilterer',
		'randomPartitioner',
		'dataset',
		'trainingSet',
		'validationSet',
		'testSet'
	],
	#category : #SuggestingNamesExperiment
}

{ #category : #accessing }
NGDatasetManager >> dataset [
	^ dataset
]

{ #category : #initialization }
NGDatasetManager >> initialize [ 
	super initialize.
	datasetBuilder := NGDatasetBuilder new.
	datasetFilterer := NGDatasetFilterer new.
	randomPartitioner := RandomPartitioner new.
]

{ #category : #public }
NGDatasetManager >> loadDataset [
	dataset := DataFrame readFromCsv: self pathToDataset 
]

{ #category : #public }
NGDatasetManager >> loadTestSet [
	testSet := DataFrame readFromCsv: self pathToTestSet 
]

{ #category : #public }
NGDatasetManager >> loadTrainingSet [
	trainingSet := DataFrame readFromCsv: self pathToTrainingSet 
]

{ #category : #public }
NGDatasetManager >> loadValidationSet [
	validationSet := DataFrame readFromCsv: self pathToValidationSet 
]

{ #category : #private }
NGDatasetManager >> pathToDataDirectory [
	^ '/Users/oleks/Documents/Research/Data' asFileReference
]

{ #category : #private }
NGDatasetManager >> pathToDataset [
	^ self pathToDataDirectory / 'methods.csv'
]

{ #category : #private }
NGDatasetManager >> pathToTestSet [
	^ self pathToDataDirectory / 'methods_test.csv'
]

{ #category : #private }
NGDatasetManager >> pathToTrainingSet [
	^ self pathToDataDirectory / 'methods_training.csv'
]

{ #category : #private }
NGDatasetManager >> pathToValidationSet [
	^ self pathToDataDirectory / 'methods_validation.csv'
]

{ #category : #public }
NGDatasetManager >> prepareDataset [
	dataset := datasetBuilder buildDataset.
	dataset := datasetFilterer filterDataset: dataset.
]

{ #category : #public }
NGDatasetManager >> saveDataset [
	dataset writeToCsv: self pathToDataset
]

{ #category : #public }
NGDatasetManager >> saveTrainingValidationAndTestSets [
	trainingSet writeToCsv: self pathToTrainingSet.
	validationSet writeToCsv: self pathToValidationSet.
	testSet writeToCsv: self pathToTestSet.
]

{ #category : #public }
NGDatasetManager >> splitDatasetIntoTrainingValidationAndTestSets [
	| subsets |
	
	subsets := randomPartitioner
		split: dataset
		withProportions: self trainingValidationTestSetProportions.
	
	trainingSet := subsets first.
	validationSet := subsets second.
	testSet := subsets third.
]

{ #category : #accessing }
NGDatasetManager >> testSet [
	^ testSet
]

{ #category : #accessing }
NGDatasetManager >> trainingSet [
	^ trainingSet
]

{ #category : #public }
NGDatasetManager >> trainingValidationTestSetProportions [
	^ #(0.7 0.1 0.2)
]

{ #category : #accessing }
NGDatasetManager >> validationSet [
	^ validationSet
]
