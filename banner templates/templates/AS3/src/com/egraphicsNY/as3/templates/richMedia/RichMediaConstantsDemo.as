package com.egraphicsNY.as3.templates.richMedia{
/* 	this cann't work because the sub class does not see the parrents class class SingletonEnforcer{}
	and if we add class SingletonEnforcer{} to bottom of the file parent will not recognize ot as 
	same as it class SingletonEnforcer{} */
	
	public final class RichMediaConstantsDemo extends RichMediaConstants{
		public function RichMediaConstantsDemo($enforcer:SingletonEnforcer){
			super($enforcer);
		}
	}
}
class SingletonEnforcer{}