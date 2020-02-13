Extension { #name : #NgramModel }

{ #category : #'*SuggestingNamesExperiment' }
NgramModel >> trainOnMethods: aCollectionOfMethods [
	(1 to: aCollectionOfMethods size) do: [ :i |
		self trainOnSentence: (aCollectionOfMethods at: i)
	] displayingProgress: [ :i | 'Training n-gram model on method ', i asString ].
]
