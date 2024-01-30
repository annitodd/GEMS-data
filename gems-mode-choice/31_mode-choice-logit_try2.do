*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* TITLE:  Mode Choice Logit -- fractional split logit 				
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* - start with a "wide" dataset, where each row is one observation      						
* - This stackexchange is perhaps the most useful example of using fractional 
* 	split logit; a printout of it is in the github folder:
* -	https:stats.stackexchange.com/questions/597355/proper-approach-for-modeling-multi-class-probabilities-proportions-compositiona
* - Code started by Annika right before she left, Jan 2024. annika.todd.blick@gmail.com 
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 


*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
**# Startup												
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
clear all
// install package fmlogit
	ssc install fmlogit
// set data folders
	global data_folder = "C:\FHWA_R2\mode_choice_estimation\data"
	global output_folder = "C:\FHWA_R2\mode_choice_estimation\output"
	global datestamp = c(current_date)
// FORMAT p-vals and numbers for results (esp useful for logits)
	set sformat %5.0g
	set pformat %5.0g
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
**#  Open Data
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
use "$data_folder\use_to_test_fmlogit.dta"

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
**#  Create / Modify vars
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
gen NSenior_YN = 0
replace NSenior_YN = 1 if strpos(id_comb, "NSenior") > 0
order NSenior_YN

gen HiInc_YN = 0
replace HiInc_YN = 1 if strpos(id_comb, "HiInc") > 0
order HiInc_YN


*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
**#  Fractional Split Logit
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* NOTE: logits hard to interpret so basically you only want to look at the 
* second step, the step with the margins and the pwcompare 

// estimate logit (the first vars are ys, eta is the x vars)
	fmlogit m_bike m_bus m_hv m_rail m_taxi m_walk, eta( 					 ///
		inv_time_permile_bike 	inv_time_permile_walk	inv_time_permile_hv	 ///	
		inv_time_permile_rail 	inv_time_permile_taxi	inv_time_permile_bus ///
		access_time_bus			access_time_rail		access_time_taxi	 ///
		wait_time_bus			wait_time_rail			wait_time_taxi		 ///
		cost_permile_bus		cost_permile_hv			cost_permile_rail 	 ///	
		cost_permile_taxi )
// now look at marginal effects. This generates predicted probabilities. The number in the dy/dx is the probability. 
	margins, dydx(* ) predict(outcome(m_bike))   // inv_* is all the inv vars
	margins, dydx(* ) predict(outcome(m_bus ))   
	margins, dydx(* ) predict(outcome(m_hv  ))   
	margins, dydx(* ) predict(outcome(m_rail))   
	margins, dydx(* ) predict(outcome(m_taxi))   
	margins, dydx(* ) predict(outcome(m_walk))   
	
	
// possibly we want to specify "atmeans" 
	margins, dydx(* ) predict(outcome(m_bike))	atmeans
	margins, dydx(* ) predict(outcome(m_bus ))  atmeans 
	margins, dydx(* ) predict(outcome(m_hv  ))  atmeans
	margins, dydx(* ) predict(outcome(m_rail))  atmeans
	margins, dydx(* ) predict(outcome(m_taxi))  atmeans
	margins, dydx(* ) predict(outcome(m_walk))  atmeans

	
	
	
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
**#  Statistical tests of logit
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* YOU CAN ONLY DO THIS RIGHT AFTER A LOGIT AND THEN A MARGINS!!
* If you want to do stat tests! otherwise it doesn't work!!!	

	// THIS ISNT WORKING WHY NOT
	pwcompare inv_time_permile_taxi, effects 
	// This test works
	test (_b[cost_permile_hv] = 0) 

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
**# Notes and discarded code:	
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// 17 weeks
		//firthlogit YNreferred_17weeks i.Tr123 , or 
		// margins i.Tr123 , post expression(invlogit(predict(xb))) 
		// pwcompare i.Tr123, effects 

		

/*
logistic YNreferred_17weeks i1.YNreferred_before#ibn.Tr123 i0.YNreferred_before#ibn.Tr123 if YNreferred_before==1,  or noconstant
			margins i.YNreferred_before##ibn.Tr123 
// Now, test whether response rates are different		
			firthlogit YNreferred_17weeks i1.YNreferred_before#i.Tr123 i0.YNreferred_before#i.Tr123,  or  
			margins i.YNreferred_before##i.Tr123 , predict() post
			pwcompare Tr123#i1.YNreferred_before , effects
			pwcompare Tr123#i0.YNreferred_before , effects 
		// Generate rest of odds ratios 
			pwcompare i.YNreferred_before##i.Tr123 , eform
			
			margins i.Tr123 , post expression(invlogit(predict(xb)))
//	I don't think we want to use this one but should look into it -- we used it for firth logit in kim's paper
	margins, dydx(* ) expression(invlogit(predict(m_walk)))
			
	*/		




/*

Variable				N		Mean		SD			Min			Max
					
bike_access_time		1613	0			0			0			0
wait_time_bike			1613	0			0			0			0
inv_time_permile_bike	1613	12.15857	10.20364	1.538619	172.9763
cost_permile_bike		1613	0			0			0			0
access_time_bus			1663	6.824921	6.067682	0			80
wait_time_bus			1663	9.222223	6.433659	0			50
inv_time_permile_bus	1663	9.374075	23.65306	0.6311538	725.6796
cost_permile_bus		1663	0.7571093	1.921651	0			40.17104
access_time_hv			3503	0			0			0			0
wait_time_hv			3503	0			0			0			0
inv_time_permile_hv		3503	5.616969	8.670078	1.041086	251.4531
cost_permile_hv			3503	0.2052918	0.3863768	0.0688721	8.158524
access_time_rail		837		10.59951	8.487648	0			60
wait_time_rail			837		9.798812	9.544526	0			89
inv_time_permile_rail	837		5.902963	21.242		0.6484243	600.3185
cost_permile_rail		837		0.708724	1.344022	0.0037018	18.15642
access_time_taxi		1134	0.2056667	1.342271	0			25
wait_time_taxi			1134	0.5576442	2.561525	0			30
inv_time_permile_taxi	1134	7.009229	13.56545	0.6734611	329.8153
cost_permile_taxi		1134	3.460153	3.522985	0.9599999	50.4323
access_time_walk		1756	0			0			0			0
wait_time_walk			1756	0			0			0			0
inv_time_permile_walk	1756	26.69037	31.18225	0.7082153	571.6486
cost_permile_walk		1756	0	0	0	0
m_bike	3504	0.0100581	0.0214073	0	0.3333333
m_bus	3504	0.0134717	0.0294782	0	0.3333333
m_hv	3504	0.895447	0.1454037	0	1
m_rail	3504	0.010151	0.0372186	0	0.4705882
m_taxi	3504	0.0061239	0.0196899	0	0.3333333
m_walk	3504	0.0647484	0.1316556	0	1

*/