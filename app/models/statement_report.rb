class StatementReport < Report

  REPORT_TYPES = { 
  	monthly_statements: "Monthly Statements",
  	only_specific_dates: "Only Specific Dates",
   	reprint_last_statement: "Reprint The Last Statement",
   	from_last_zero_or_credit_balance: "From Last Zero or Credit Balance",
   	year_to_date_payments: "Year to Date (End of Year) Payments",
   	clean_statements: "Clean Statements" 
 	}
  
  SERVICES 		= ["All services", "Unpaid Services", "Paid Services", "No Services", "Insurance Billable", "Non-Insurance Billable"]
  STATEMENTS 	= ["All Payments & Adjustments", "Only Patient Payments", "Only Insurance Payments", "Only Insurance Adjustments", "Only Patient Balance Adjustments", "No Payments"]
  STATEMENT_PROCEDURE_CODE_NAME = "Statmt"
end