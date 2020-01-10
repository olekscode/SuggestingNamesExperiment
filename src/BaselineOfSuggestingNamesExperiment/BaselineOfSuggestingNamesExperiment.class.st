Class {
	#name : #BaselineOfSuggestingNamesExperiment,
	#superclass : #BaselineOf,
	#category : #BaselineOfSuggestingNamesExperiment
}

{ #category : #baselines }
BaselineOfSuggestingNamesExperiment >> baseline: spec [
	<baseline>
	spec for: #common do: [	
		"External dependencies"
		spec
			baseline: 'PharoCodeTokenizer'
			with: [ spec repository: 'github://olekscode/PharoCodeTokenizer/src' ].
			
		spec
			baseline: 'NgramModel'
			with: [ spec repository: 'github://olekscode/NgramModel/src' ].
			
		spec
			baseline: 'Polyglot'
			with: [ spec repository: 'github://PolyMathOrg/Polyglot/src' ].
			
		spec
			baseline: 'DataFrame'
			with: [ spec repository: 'github://PolyMathOrg/DataFrame/src' ].
			
		spec
  			baseline: 'RandomPartitioner'
  			with: [ spec repository: 'github://PharoAI/RandomPartitioner/src' ].
				
		"Packages"
		spec 
			package: 'SuggestingNamesExperiment' with: [ spec requires: #('PharoCodeTokenizer' 'NgramModel' 'Polyglot' 'DataFrame' 'RandomPartitioner') ];
			package: 'SuggestingNamesExperiment-Tests' with: [ spec requires: #('SuggestingNamesExperiment') ] ].
]
