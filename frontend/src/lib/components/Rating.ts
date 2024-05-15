export type RatingType =
	// single heart 0/10
	| "heart"
	// sad-neutral-happy faces 0/3/7/10
	| "mood"
	// 3 stars 0/3/7/10
	| "stars3"
	// 5 stars 0/2/4/6/8/10
	| "stars5"
	// 5 stars with half stars 0/1/2/3/4/5/6/7/8/9/10
	| "stars10";
