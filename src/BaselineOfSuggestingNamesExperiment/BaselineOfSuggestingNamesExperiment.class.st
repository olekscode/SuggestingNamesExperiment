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
			baseline: 'NgramModel'
			with: [ spec repository: 'github://olekscode/NgramModel/src' ].
			
		spec
			baseline: 'Polyglot'
			with: [ spec repository: 'github://PolyMathOrg/Polyglot/src' ].
			
		spec
			baseline: 'DataFrame'
			with: [ spec repository: 'github://PolyMathOrg/DataFrame/src' ].
				
		"Packages"
		spec 
			package: 'SuggestingNamesExperiment' with: [ spec requires: #('NgramModel' 'Polyglot' 'DataFrame') ];
			package: 'SuggestingNamesExperiment-Tests' with: [ spec requires: #('SuggestingNamesExperiment') ] ].
]
