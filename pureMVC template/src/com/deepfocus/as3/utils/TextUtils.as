//AUTHOR: REMI

/**
 RECENT CHANGES:
 * 11/23/09: Added getLineAscent() and getLineDescent() functions.
 * 11/21/10: Added standardTextField getter.
 * 12/26/10: Correted typo in getLineAscent() function name
 * 04/23/12: Modified enterBoundedText() function to allow for non-CSS-controlled fields
 * 04/24/12: Added enterTextAndSizeToFit() function.
 */

package com.deepfocus.as3.utils{
	import com.adobe.utils.ArrayUtil;
	import com.deepfocus.as3.display.layout.*;
	
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.describeType;
	
	/**
	 * A utility class that executes a number of textField-related functions. */
	public class TextUtils{
		
		/** Returns a value for the adjusted y-position of a textField, ignoring the extra whitespace
		 * above the first line of text. This acts as a new origin point on the y-axis, whereby the 
		 * first line of text would flush perfectly with other objects at 0.*/
		public static function getAdjustY(tField:TextField):Number{
			var metrics:TextLineMetrics = tField.getLineMetrics(0);
			var descentRatio:Number = tField.height / metrics.descent;
			var adjustY:Number;
			
			if(descentRatio < 5)		adjustY = tField.y - (tField.height - metrics.ascent);
			else						adjustY = tField.y - (tField.height - metrics.ascent - metrics.descent);
			
			return adjustY;
		}
		
		/** Returns a value for the width of a line of text.*/
		public static function getLineWidth(tField:TextField, lineNum:Number=NaN):Number{
			if(isNaN(lineNum))		lineNum = tField.numLines - 1;
			var metrics:TextLineMetrics = tField.getLineMetrics(lineNum);
			var lWidth:Number = metrics.width;
			
			//accomodate for needlessly-added final lines
			if(lineNum > 0 && lWidth == 0)		lWidth = tField.getLineMetrics(lineNum - 1).width;
			
			return lWidth;
		}
		
		/** Returns a value for the height of a line of text, ignoring any extra whitespace.*/
		public static function getLineHeight(tField:TextField, lineNum:Number=NaN):Number{
			if(isNaN(lineNum))		lineNum = tField.numLines - 1;
			var metrics:TextLineMetrics = tField.getLineMetrics(lineNum);
			var lHeight:Number = metrics.ascent + metrics.descent;
			
			return lHeight;
		}
		
		/** Returns a value for the leading applied to a line of text.*/
		public static function getLineLeading(tField:TextField, lineNum:Number=NaN):Number{
			if(isNaN(lineNum))		lineNum = tField.numLines - 1;
			var metrics:TextLineMetrics = tField.getLineMetrics(lineNum);
			
			return metrics.leading;
		}
		
		
		
		/** Returns a value for the ascent value of a line of text.*/
		public static function getLineAscent(tField:TextField, lineNum:Number=NaN):Number{
			if(isNaN(lineNum))		lineNum = tField.numLines - 1;
			var metrics:TextLineMetrics = tField.getLineMetrics(lineNum);
			
			return metrics.ascent;
		}
		
		/** Returns a value for the descent value of a line of text.*/
		public static function getLineDescent(tField:TextField, lineNum:Number=NaN):Number{
			if(isNaN(lineNum))		lineNum = tField.numLines - 1;
			var metrics:TextLineMetrics = tField.getLineMetrics(lineNum);
			
			return metrics.descent;
		}
		
		
		/** Returns a zero-based integer representing the line on which the caret is positioned
		 * at a given time.*/
		public static function currentLine(tField:TextField):int{
			var lineHt:Number = getLineHeight(tField);
			var numLine:int = Math.round(getCaretPosition(tField).y/lineHt);
			
			return numLine;
		}
		
		
		/** Returns x-y coordinates of the caret at any point. */
		public static function getCaretPosition(tField:TextField):Point{
			var caretBounds:Rectangle = tField.getCharBoundaries(tField.caretIndex - 1);
			var pos:Point = new Point(0,0);
			
			//get caret index
			if(caretBounds){
				pos.x = caretBounds.x;
				pos.y = caretBounds.y;
			}else{
				//cases of new (empty) lines
				var txtSplit:Array = [tField.text.substr(0, tField.caretIndex), ' '];
				if(tField.caretIndex < tField.length){
					txtSplit[2] = tField.text.substr(tField.caretIndex, tField.length);
				}
				//add space and quickly determine character boundaries
				tField.text = txtSplit.join('');
				pos.y = tField.getCharBoundaries(tField.caretIndex).y;
				//remove extra space and reset text
				ArrayUtil.removeValueFromArray(txtSplit, ' ');
				tField.text = txtSplit.join('');
			}
			
			return pos;
		}
		
		/** Enters formatted text into textfield, resizing it when it threatens to exceed the specified bounds.
		 * @tf The textField in question.
		 * @txt The text to be entered into the text field.
		 * @bounds The vertical and/or horizontal bounds to be respected by the textfield.
		 * @sacredWords An array holding the indices of words whose formatting is to be preserved. */
		public static function enterTextAndSizeToFit(tf:TextField, txt:String, bounds:Object, minFontSize:Number=2, sacredWordIndices:Array=null):void{
			/*with no height restrictions, a multiline textField can extend infinitely,
			thus rendering any sizing calculations a wasted exercise. */
			if(!bounds.height && tf.multiline){
				tf.text = txt;
				return;
			}
			
			var incText:String = '';		//text to be displayed, incremented by character
			var totalHeight:Number = 0;		//total textField height with each added char
			var curLine:int = 0;			//current number of lines in textField
			var maxLines:Number;			//max allowable line count, as defined by bounds. Not an int because of possible Infinity value
			var words:Array = StringUtils.getWordArray(txt);
			var wordCount:Number = words.length;
			var sacredBounds:Object = new Object();
			var diffPct:Number;				//the percentage by which the non-sacred words will need to be scaled down to fit into the space
			var fmt:TextFormat = tf.getTextFormat();
			var fmt2:TextFormat = tf.getTextFormat();
			var boundsArea:Number;			//the maximum area to be covered by the text
			var sBoundsArea:Number;			//the area covered by the sacred words
			var fullArea:Number;			//the area covered by the text if unformatted
			var buffer:int = 1;				//buffer pixel dimensions
			var tfProps:Object = getProperties(tf);	//log properties before changing anything
			var rndError:Number = .9616;
			var curSword:String;
			var sWordIndex:int;
			var i:int = -1;
			var ltSpacing:Number = fmt.letterSpacing as Number;
			
			//trace('');
			//trace('TXT '+txt);
			//trace('autoSize '+ tf.autoSize, 'props '+tfProps.autoSize);
			
			//trace('tf.x '+tf.x, 'wid '+tf.width);
			//enter full text to get fullArea and text metrics
			tf.multiline = false;
			if(fmt.align == TextFormatAlign.RIGHT)	tf.autoSize = TextFieldAutoSize.RIGHT;
			else									tf.autoSize = TextFieldAutoSize.LEFT;
			tf.text = txt;		
			fullArea = tf.width* tf.height* rndError;
			
			tf.multiline = tfProps.multiline;
			
			//waste no further time if sizing request is flawed
			if(fmt.size < minFontSize){
				fmt.size = minFontSize;
				tf.setTextFormat(fmt2);
				return;
			}
			
			if(!bounds.height){	//assuming not multiline, per above conditional return
				bounds.height = tf.height + buffer;
			}else{
				/*if field isn't multiline, and yet (as a one-liner,) is shorter than the bounds area, make it multiline to fill the space
				(for a single-line element, bounds.height should remain null) */
				if(!tf.multiline && bounds.height > tf.textHeight + buffer){
					tf.multiline = tf.wordWrap = true;
					tf.height = bounds.height + buffer;
				}
				//CONSIDER: IF MULTILINE IS NEEDED, SHOULD BE SET OUTSIDE THIS UTIL
			}
			boundsArea = bounds.width* bounds.height;
			
			if(fullArea < boundsArea)		return;
			
			//go straight through if no word is sacred
			if(!sacredWordIndices){
				//decrease font size until the text fits
				while ((tf.width* tf.height) >= boundsArea){
					fmt2.size = Math.max(minFontSize, int(fmt2.size) - 1);
					ltSpacing = Number(fmt.letterSpacing) - (Number(fmt.size) - Number(fmt2.size))/ Number(fmt.size)* Number(fmt.letterSpacing);
					fmt2.letterSpacing = ltSpacing;
					//fmt2.size = int(fmt2.size) - 1;
					tf.setTextFormat(fmt2);
					if(fmt2.size == minFontSize)	break;
				}
				
				if(tf.width > bounds.width)		tf.width = Math.max(bounds.width, tf.textWidth);
				if(tf.height > bounds.height)	tf.height = bounds.height;
				
				if(tf.autoSize != TextFieldAutoSize.RIGHT)		tf.x = tfProps.x;
				else											tf.x = tfProps.x + tfProps.width - tf.width;
				
				tf.multiline = tfProps.multiline;
				tf.wordWrap = tfProps.wordWrap;
				tf.autoSize = tfProps.autoSize;
				/*tf.y = tfProps.y;*/
				return;
			}
			
			//enter sacred words to get an idea of the resizing need
			tf.text = '';
			while(++i < sacredWordIndices.length){
				if(!StringUtils.getWordByIndex(txt, sacredWordIndices[i]))		continue;
				if(i == 0)	incText += StringUtils.getWordByIndex(txt, sacredWordIndices[i]);
				else		incText += ' '+ StringUtils.getWordByIndex(txt, sacredWordIndices[i]);
			}
			
			tf.text = incText;
			sacredBounds.width = tf.textWidth;
			sacredBounds.height = tf.textHeight;
			sBoundsArea = sacredBounds.width* sacredBounds.height;
			
			//restore tf properties
			tf.width = bounds.width + buffer;
			tf.height = bounds.height + buffer;
			tf.autoSize = tfProps.autoSize;
			
			//address cases where even sacred words don't fit into the space (obviously a design error)
			if(sBoundsArea > boundsArea){
				diffPct = boundsArea/sBoundsArea;
				//sBoundsArea = sacredBounds.width = sacredBounds.height = 0;
			}
			else	diffPct = (boundsArea - sBoundsArea)/(fullArea - sBoundsArea);
			diffPct = (boundsArea - sBoundsArea)/(fullArea - sBoundsArea);
			fmt2.size = Object(Number(fmt.size)* diffPct);
			
			tf.defaultTextFormat = fmt2;
			tf.text = txt;
			
			i = -1;
			//reformat sacred words one by one
			while(++i < sacredWordIndices.length){
				curSword = words[sacredWordIndices[i]];
				sWordIndex = StringUtils.getCharIndexByWordIndex(txt, sacredWordIndices[i]);
				tf.setTextFormat(fmt, sWordIndex, sWordIndex + curSword.length);
			}
		}
		
		
		/** Enters formatted text into textfield, truncating it when it threatens to exceed the specified bounds.
		 * @tf The textField in question.
		 * @txt The text to be entered into the text field.
		 * @bounds The vertical and/or horizontal bounds to be respected by the textfield. */
		public static function enterBoundedText(tf:TextField, txt:String, bounds:Object, styles:Object):void{
			/*with no height restrictions, a multiline textField can extend infinitely,
			thus rendering any sizing calculations a wasted exercise. */
			if(!bounds.height && tf.multiline){
				setText(tf, txt, styles);
				return;
			}
			
			var incText:String = '';		//text to be displayed, incremented by character
			var totalHeight:Number = 0;		//total textField height with each added char
			var curLine:int = 0;			//current number of lines in textField
			var maxLines:Number;			//max allowable line count, as defined by bounds. Not an int because of possible Infinity value
			var ellipWidth:Number;			//width of ellipsis in formatted TF
			var words:Array = StringUtils.getWordArray(txt);
			var wordCount:Number = words.length;
			var lastLine:Boolean;
			var ellipsis:String = '...';
			var i:int = -1;
			
			getProperties(tf);
			
			//show ellipsis in TF to set ellipWidth and maxLines values
			setText(tf, 'Test', styles);
			//maxLines = Math.ceil(bounds.height/getLineHeight(tf));
			if(bounds.height)	maxLines = Math.ceil(bounds.height/tf.textHeight);
			else				maxLines = Number.POSITIVE_INFINITY;	//assume not multiline
			ellipWidth = getLineWidth(tf) + 1;	//for 2-pixel gutter
			
			//add words one by one
			while(++i < words.length){
				if(i == 0)		incText += StringUtils.getWordByIndex(txt, i);
				else			incText += ' '+ StringUtils.getWordByIndex(txt, i);
				
				//if text ends in a period, kill it before adding ellipsis
				if(incText.charAt(incText.length - 1) == '.')	ellipsis = '..';
				else											ellipsis = '...';
				
				//add ellipsis to the new word, to check overflow
				setText(tf, incText + ellipsis, styles);
				
				lastLine = ((tf.numLines == maxLines) || (maxLines = Number.POSITIVE_INFINITY));
				
				//if new word has crossed the bounds, dial text back and truncate.
				if(tf.numLines > maxLines || (lastLine && getLineWidth(tf) >= Math.min(tf.width, bounds.width))){
					incText = StringUtils.getWordRange(txt, 0, i -1);
					
					incText = StringUtils.addEllipsis(incText); //add ellipsis
					setText(tf, incText, styles);
					
					return;
				}else{
					setText(tf, incText, styles);
				}
			}
		}
		
		
		/** Helper function for enterBoundedText. Handles the stylesheet conditional. */
		private static function setText(tf:TextField, txt:String, styles:Object=null):void{
			if(styles){
				var openTag:String = "<"+styles.tag;
				if(styles.className)	openTag += " class='"+styles.className + "'";
				openTag += ">";
				tf.htmlText = openTag + txt + "</"+ styles.tag +">";
				
				/*trace("styles.className "+styles.className);
				trace("openTag "+openTag);*/
			}
			else		tf.text = txt;
		}
		
		
		/** Returns a full list of a given textField's properties. */
		public static function getProperties(tf:TextField):Object{
			var obj:Object = new Object();		
			var def:XML = describeType(tf);			
			var properties:XMLList = def..variable.@name + def..accessor.@name;
			
			for each (var property:String in properties){
				try{obj[property] = tf[property];
				}catch(e:*){}
			}
			
			return obj;
		}
		
		//GET AND SET
		
		/** Creates and returns a standard textField as it will be used on most projects. */
		public static function get standardTextField():TextField{
			var tf:TextField = new TextField();
			
			tf.embedFonts = true;
			tf.selectable = false;
			tf.multiline = tf.wordWrap = false;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.mouseEnabled = false;
			tf.sharpness = 50;
			
			return tf;
		}
		
	}
}