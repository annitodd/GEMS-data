*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* TITLE:  Mode Choice Logit -- fractional split logit 				
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/* 	- start with a "wide" dataset, where each row is one observation      						
 	- This is perhaps the most useful example of using fractional split logit;  
	- I made a copy of that stackexchange and put it in the github folder	https:stats.stackexchange.com/questions/597355/proper-approach-for-modeling-multi-class-probabilities-proportions-compositiona
	- Annika started this code right before she left in Jan 2024. annika.todd.blick@gmail.com */
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 


*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
**# Startup												
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
**#  Open Data
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
use "$data_folder\use_to_test_fmlogit.dta"

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
**#  Fractional Split Logit
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/* NOTE: logits hard to interpret so basically you only want to look at the second step, 
the step with the margins and the pwcompare */ 

// estimate logit
	fmlogit m_bike m_bus m_hv m_rail m_taxi m_walk, eta(c.inv_time_permile_taxi ) nolog
	/* the first variables before the comma are the y variables, and the ones in the eta are the x vars */
	



	
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
**# RESPONSE RATE of the treated clients: did they give any nominations YN?		
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	// 17 weeks
		firthlogit YNreferred_17weeks i.Tr123 , or 
		margins i.Tr123 , post expression(invlogit(predict(xb))) // generates predicted probabilities
		pwcompare i.Tr123, effects //tests diffrences between predicted probabilities
		display "RegrDf:"e(df_r) "RegrN:"e(N) " PwtestN:" r(N) " PwtestDf:" r(df_r)
		test (_b[1.Tr123] = _b[2.Tr123]) 
		test (_b[1.Tr123] = _b[3.Tr123]) 
		test (_b[2.Tr123] = _b[3.Tr123])
		
		
// first do this but basically ignore it
// fmlogit governing safety education recreation social urbanplanning,  eta(i.minorityleft i.noleft c.houseval c.popdens) nolog
fmlogit m_bike m_bus m_hv m_rail m_taxi m_walk, ///
	eta(c.inv_time_permile_taxi ) nolog

margins, dydx(inv_time_permile_taxi) predict(outcome(m_bus))



/*

Variable				N		Mean		SD			Min			Max
					
bike_access_time		1613	0			0			0	0
wait_time_bike			1613	0			0			0	0
inv_time_permile_bike	1613	12.15857	10.20364	1.538619	172.9763
cost_permile_bike		1613	0			0			0	0
access_time_bus			1663	6.824921	6.067682	0			80
wait_time_bus			1663	9.222223	6.433659	0			50
inv_time_permile_bus	1663	9.374075	23.65306	0.6311538	725.6796
cost_permile_bus		1663	0.7571093	1.921651	0	40.17104
access_time_hv			3503	0			0			0	0
wait_time_hv			3503	0			0			0	0
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
access_time_walk		1756	0	0	0	0
wait_time_walk			1756	0	0	0	0
inv_time_permile_walk	1756	26.69037	31.18225	0.7082153	571.6486
cost_permile_walk		1756	0	0	0	0
m_bike	3504	0.0100581	0.0214073	0	0.3333333
m_bus	3504	0.0134717	0.0294782	0	0.3333333
m_hv	3504	0.895447	0.1454037	0	1
m_rail	3504	0.010151	0.0372186	0	0.4705882
m_taxi	3504	0.0061239	0.0196899	0	0.3333333
m_walk	3504	0.0647484	0.1316556	0	1

*/