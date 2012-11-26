package com.deepfocus.as3.utils{
	import com.adobe.utils.ArrayUtil;
	
	/**
	 * A utility class that executes a number of string-related functions. */
	public class StringUtils{
		
		/** A static class containing the letters of the alphabet, in lowercase form. */
		public static const ALPHABET:Array = ("abcdefghijklmnopqrstuvwxyz").split("");
		
		
		/** Converts first letter of each word in string to Uppercase */
		public static function toTitleCase(txt:String):String{
			var wordArr:Array;
			var newVal:String;
			var i:int;
			
			//deal with spaces first
			wordArr = txt.split(" ");			
			for(i=0; i < wordArr.length; i++){
				wordArr[i] = wordArr[i].slice(0,1).toUpperCase() + wordArr[i].slice(1).toLowerCase();
			}
			newVal = wordArr.join(" ");
			
			
			//now, deal with hyphens
			wordArr = newVal.split("-");			
			for(i=0; i < wordArr.length; i++){
				wordArr[i] = wordArr[i].slice(0,1).toUpperCase() + wordArr[i].slice(1);
			}
			newVal = wordArr.join("-");
			
			
			//and apostrophes
			wordArr = newVal.split("'");			
			for(i=0; i < wordArr.length; i++){
				wordArr[i] = wordArr[i].slice(0,1).toUpperCase() + wordArr[i].slice(1);
			}
			newVal = wordArr.join("'");
			
			//and slashes
			wordArr = newVal.split("/");			
			for(i=0; i < wordArr.length; i++){
				wordArr[i] = wordArr[i].slice(0,1).toUpperCase() + wordArr[i].slice(1);
			}
			newVal = wordArr.join("/");
			
			
			//finally, parentheses
			wordArr = newVal.split("(");			
			for(i=0; i < wordArr.length; i++){
				wordArr[i] = wordArr[i].slice(0,1).toUpperCase() + wordArr[i].slice(1);
			}
			newVal = wordArr.join("(");
			
			return newVal;
		}
		
		/** Converts string to one suitable for CounterPixel tracking.
		 * <p>Replaces spaces with underscores, and makes everything lower-case. </p> */
		public static function formatCounterPixel(txt:String):String{
			var newVal:String = replaceSubstr(txt, '-', '_').toLowerCase();
			newVal = removeSpecialChars(newVal, ['/', '_']);
			
			return replaceSubstr(newVal, ' ', '_');
		}
		
		
		/** Prepares a string for alphabetization by repositioning leading articles.
		 * <p>If a String begins with "a", "an", or "the", it is reworked to suit standard
		 * alphabetization rules. i.e., "The Murderous Lightbulb" -> "Murderous Lightbulb, The".</p>
		 */
		public static function formatAlphabetize(txt:String):String{
			var txtLow:String = txt.toLowerCase();
			var article:String;			//offending article ("The", "A", or An")
			var postArticle:String;		//substring after offending article
			
			/*lowercase version is used (but only in index check) because the case 
			structure of the initial string must remain untouched, 
			but it could be 'the' or 'The' or 'tHe'.*/
			if(txtLow.indexOf('a ') == 0)				article = txt.substr(0,2);
			if(txtLow.indexOf('an ') == 0)				article = txt.substr(0,3);
			else if(txtLow.indexOf('the ') == 0)		article = txt.substr(0,4);
			else										return txt;
			
			postArticle = txt.substr(article.length);
			
			//rework original string
			txt = postArticle + ", " + article.substr(0, article.length - 1);
			
			return txt;
		}
		
		
		/** Replaces all occurrences of a parameter subString from a parameter string with another and returns the result.*/
		public static function replaceSubstr(txt:String, sub:String, newSub:String):String{
			var charFreeArr:Array = txt.split(sub);
			var newText:String = charFreeArr.join(newSub);
			
			return newText;
		}
		
		
		/** Removes all occurrences of a parameter subString from a parameter string and returns the result.*/
		public static function removeSubstr(txt:String, sub:String):String{
			var charFreeArr:Array = txt.split(sub);
			var newText:String = charFreeArr.join('');
			
			return newText;
		}
		
		
		/** Removes all spaces from a parameter string and returns the result.*/
		public static function removeSpaces(txt:String):String{
			return removeSubstr(txt, ' ');
		}
		
		
		/** Removes all non-alphanumeric characters in a string and returns the result.*/
		public static function removeSpecialChars(txt:String, exceptions:Array=null):String{
			var offendingChars:Array = [];
			var i:int = -1;
			if(!exceptions)		exceptions = [];
			
			exceptions.push(' ');	//allow spaces
			
			while(++ i <  txt.length){
				var char:String = txt.charAt(i);
				var code:int = txt.toUpperCase().charCodeAt(i);
				var isNumer:Boolean = !isNaN(Number(char));
				var isAlpha:Boolean = (code >= 64 && code <= 90);
				
				//save references to non-alphanumeric characters that aren't in the Exceptions array
				if(!isNumer && !isAlpha && !ArrayUtil.arrayContainsValue(exceptions, char))		offendingChars.push(char);
			}
			
			i = -1;
			while(++ i <  offendingChars.length){
				//remove any non-alphanumeric characters
				txt = removeSubstr(txt, offendingChars[i]);
			}
			
			return txt;
		}
		
		
		/** Removes (presumably superfluous) spaces that occur at the end of a string.*/
		public static function removeEndSpaces(txt:String):String{
			var newText:String;
			
			//if last character is a space, kill it.
			if(txt.charAt(txt.length - 1) == ' ')		newText = txt.substr(0, txt.length - 1);
			else										newText = txt;
			
			//now, check newText (recursion).
			if(newText.charAt(newText.length - 1) == ' ')		newText = removeEndSpaces(newText);
			
			return newText;
		}
		
		
		/** Returns a word based on its 0-index-based position in the string. */
		public static function getWordByIndex(txt:String, num:int):String{
			var arr:Array = txt.split(' ');
			var wordCount:int = arr.length;
			
			if(num < 0)					num = 0;
			else if(num >= wordCount)	num = wordCount - 1;
			
			return arr[num];
		}
		
		/** Returns a word based on its 0-index-based position in the string. */
		public static function getCharIndexByWordIndex(txt:String, num:int):int{
			var arr:Array = txt.split(' ');
			var charCount:int = 0;
			var wordCount:int = arr.length;
			var i:int = -1;
			
			while(++i < wordCount){
				if(i == num)	return charCount;
				charCount += arr[i].length + 1;
			}
			
			return -1;
		}
		
		
		/** Returns a subset of a string based on the bounding word indices specified. */
		public static function getWordRange(txt:String, startIndex:int, endIndex:int):String{
			var arr:Array = txt.split(' ');
			var wordCount:int = arr.length;
			var newString:String;
			var i:int = -1;
			
			if(startIndex < 0)			startIndex = 0;
			if(endIndex >= wordCount)	endIndex = wordCount - 1;
			
			newString = getWordByIndex(txt, startIndex);
			
			while(++i < arr.length){
				if(i <= startIndex)		continue;				
				if(i <= endIndex)	newString += ' '+ getWordByIndex(txt, i);
			}
			
			return newString;
		}
		
		
		/** Returns a numerical value representing the number of words in a string. */
		public static function getWordCount(txt:String):int{
			var arr:Array = txt.split(' ');
			
			return arr.length;
		}
		
		/** Returns an array holding each word in the the string. */
		public static function getWordArray(txt:String):Array{
			return txt.split(' ');
		}
		
		
		/** Gets a substring of a string, based on a max wordcount set as a param.
		 * <p>If truncate == true, an ellipsis is added to the (new) substring.</p>
		 */
		public static function setWordCount(txt:String, max:Number, truncate:Boolean=false):String{
			var newText:String;
			var spacelessArr:Array = txt.split(' ');
			var maxTooHigh:Boolean = (max > spacelessArr.length);
			
			//ensure max wordcount isn't greater than wordcount of original string
			if(maxTooHigh)		max = spacelessArr.length;
			
			for(var i:int=0; i < max; i++){
				if(i == 0)	newText = spacelessArr[i];
				else		newText += ' '+ spacelessArr[i];
			}
			
			if(truncate && !maxTooHigh)		newText = addEllipsis(txt);
			
			return newText;
		}
		
		
		
		/** Gets a substring of a string, based on a max character-count set as a param.
		 * <p>If truncate == true, an ellipsis is added to the (new) substring.</p>
		 */
		public static function setCharacterCount(txt:String, max:Number, truncate:Boolean=false):String{
			var newText:String;
			var maxTooHigh:Boolean;
			
			txt = removeEndSpaces(txt);			//if last character is a space, kill it.
			maxTooHigh = (max >= txt.length);	//now, see if current char-count doesn't violate new max
			
			//ensure max character-count isn't greater than character-count of original string
			if(maxTooHigh)		max = txt.length;
			//make sure last character isn't a space
			if(txt.charAt(max - 1) == ' ')		max -= 1;
			
			newText = txt.substr(0, max);
			
			if(truncate && !maxTooHigh)		newText = addEllipsis(txt);
			
			return newText;
		}
		
		/** Adds an ellipsis to the end of a string, accounting for the possibility of a 
		 * period at the end of the string. */
		public static function addEllipsis(txt:String):String{
			if(txt.charAt(txt.length - 1) == '.')		txt += '..';
			else										txt += '...';
			
			return txt;
		}
		
		/** Replaces all occurrences of a specified character with a superscripted version.
		 * @txt The full source text containing the character to be superscripted.
		 * @char The character to be superscripted.
		 * @size The point value to be applied to the superscripted character font. */
		public static function swapSuper(txt:String, char:String, size:Number=NaN):String{
			//var txt:String = 'd'
			var expArr:Array = txt.split(char);		//splits string by incidence of the char to be superscripted
			var superSize:String;					//the font size to be applied to the superscripted character
			var newStr:String = '';			//will hold the new, reformatted string
			var i:int = -1;
			
			//trace(txt);
			
			//escape if there are no offending characters
			if(expArr.length == 1)		return txt;
			
			//split the full string by occurrence of the character to be superscripted
			while(++i < expArr.length){
				var tagArr:Array = expArr[i].split('<font');		//splits string by incidence of opening <font> tag
				var charRep:String = "<font face='GG Superscript'>"+char+"</font>";			//replacement for character
				var lastTag:String = '<font'+tagArr[tagArr.length - 1];		//all text from last <font> tag to char
				var onlyTag:String = lastTag.substring(0, lastTag.indexOf('>')+1)	//contains ONLY last font tag
				var j:int = -1;
				
				//find font size, first in font tags of text preceding special character
				if(onlyTag.indexOf("size='") > -1){
					var sizeVal:String = onlyTag.split("size='")[1];
					superSize = sizeVal.split("'")[0];
				}
				//but override any findings if a point size for the superscript character was passed as a param
				if(!isNaN(size))	superSize = String(size);
				//apply superscript font size, if any
				if(superSize)		charRep = "<font face='GG Superscript' size='"+superSize+"'>"+char+"</font>";
				
				//modify charRep if unclosed <font> tag comes before character
				if(tagArr.length > 1 && lastTag.indexOf('</font>') == -1){
					charRep = "</font>" + charRep + onlyTag;
				}
				
				//update newStr
				if(i < expArr.length - 1)		newStr += expArr[i] + charRep;
				else							newStr += expArr[i];
			}
			//end exp loop
			/*trace("final ");
			trace(newStr);
			trace("");*/
			
			return newStr;
		}
		
		
		/** Strips out the contents of a sub-node (probably defined in a templating language), returning an 
		 * Array made of Object instances -- one for each subnode occurence, and each with two attributes.
		 * The text attribute refers simply to the text contained between the subNode's opening and closing tags.
		 * The startIndex attribute refers to the character-index of each subNode-text instance in a string from
		 * which all node tags (opening and closing) have been stripped. */
		public static function extractCustomNodes(txt:String, nodeName:String):Array{
			var objects:Array = [];
			var startNode:String = "<$$"+nodeName+">";
			var endNode:String = "<$$/"+nodeName+">";
			var arr:Array = txt.split(startNode);
			var lastInd:int = 0;
			var i:int = -1;
			
			while(++i < arr.length){
				var subLength:int = arr[i].indexOf(endNode);
				if(subLength == -1){
					lastInd += arr[i].length;
				}else{
					var obj:Object = {startIndex:lastInd};
					
					arr[i] = removeSubstr(arr[i], endNode);
					obj.text = arr[i].substr(0, subLength);
					lastInd += arr[i].length;
					
					objects.push(obj);
				}
			}
			
			return objects;
		}
		
		
		/** Strips out the tags marking a sub-node (probably defined in a templating language), returning simple
		 * String devoid of any custom-node markers. */
		public static function stripCustomNodeTags(txt:String, nodeName:String):String{
			var startNode:String = "<$$"+nodeName+">";
			var endNode:String = "<$$/"+nodeName+">";
			var arr:Array = txt.split(startNode);
			var i:int = -1;
			
			while(++i < arr.length){
				var subLength:int = arr[i].indexOf(endNode);
				if(arr[i].indexOf(endNode) > -1){
					arr[i] = removeSubstr(arr[i], endNode);
				}
			}
			
			return arr.join('');
		}
		
		
		
		/**Gets a nesting structure from the deepLink path provided.
		 *<p>Receives a string value in which levels are separated by slashes. An array is
		 *created by splitting the string at each slash. Each element of the resulting array will 
		 *exist one level deeper than the one preceding it.
		 */
	}
}