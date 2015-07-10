/*
 * Scratch Project Editor and Player
 * Copyright (C) 2014 Massachusetts Institute of Technology
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

package ui {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import assets.Resources;
	import blocks.*;
	import uiwidgets.*;
	import util.*;
	import translation.Translator;

public class RecordingSpecEditor extends Sprite {

	private var base:Shape;
	private var row:Array = [];

	private var moreLabel:TextField;
	private var moreButton:IconButton;
	private var checkboxLabels:Array = [];
	private var checkboxes:Array = [];

	private var toggleOn:Boolean;

	private const labelColor:int = 0x8738bf; // 0x6c36b3; // 0x9c35b3;

	public function RecordingSpecEditor() {
		addChild(base = new Shape());
		setWidthHeight(350, 10);

		addChild(moreLabel = makeLabel('Options', 12));
		moreLabel.addEventListener(MouseEvent.MOUSE_DOWN, toggleButtons);

		addChild(moreButton = new IconButton(toggleButtons, 'reveal'));
		moreButton.disableMouseover();

		addCheckboxesAndLabels();

		checkboxes[0].setOn(true);
		showButtons(false);
		fixLayout();
	}

	private function setWidthHeight(w:int, h:int):void {
		var g:Graphics = base.graphics;
		g.clear();
		g.beginFill(CSS.white);
		g.drawRect(0, 0, w, h);
		g.endFill();
	}

	public function spec():String {
		var result:String = '';
		for each (var o:* in row) {
			if (o is TextField) result += ReadStream.escape(TextField(o).text);
			if ((result.length > 0) && (result.charAt(result.length - 1) != ' ')) result += ' ';
		}
		if ((result.length > 0) && (result.charAt(result.length - 1) == ' ')) result = result.slice(0, result.length - 1);
		return result;
	}

	public function soundFlag():Boolean {
		// True if the 'include sound from project' box is checked.
		return checkboxes[0].isOn();
	}
	
	public function editorFlag():Boolean {
		// True if the 'include sound from project' box is checked.
		return checkboxes[2].isOn();
	}

	public function microphoneFlag():Boolean {
		// True if the 'include sound from microphone' box is checked.
		return checkboxes[1].isOn();
	}
	
	public function mouseFlag():Boolean {
		// True if the 'include sound from microphone' box is checked.
		return checkboxes[3].isOn();
	}
	
	public function fifteenFlag():Boolean {
		// True if the 'include sound from microphone' box is checked.
		return checkboxes[4].isOn();
	}

	private function addCheckboxesAndLabels():void {
		checkboxLabels = [
		makeLabel('Include sound from project', 14),
		makeLabel('Include sound from microphone', 14),
		makeLabel('Record entire editor',14),
		makeLabel('Show mouse clicks',14),
		makeLabel('Record at 15 fps (instead of 30)',14),
		];
		checkboxes = [
		new IconButton(null, 'checkbox'),
		new IconButton(null, 'checkbox'),
		new IconButton(null, 'checkbox'),
		new IconButton(null, 'checkbox'),
		new IconButton(null, 'checkbox'),
		];

		for each (var label:TextField in checkboxLabels) addChild(label);
		for each (var b:IconButton in checkboxes) {
			b.disableMouseover();
			addChild(b);
		}
	}

	private function makeLabel(s:String, fontSize:int):TextField {
		var tf:TextField = new TextField();
		tf.selectable = false;
		tf.defaultTextFormat = new TextFormat(CSS.font, fontSize, CSS.textColor);
		tf.autoSize = TextFieldAutoSize.LEFT;
		tf.text = Translator.map(s);
		addChild(tf);
		return tf;
	}

	private function toggleButtons(ignore:*):void {
		showButtons(!toggleOn)
	}

	private function showButtons(showParams:Boolean):void {
		var label:TextField, b:IconButton;
		var height:int = 55;
		if (showParams) {
			toggleOn = true;
			for each (label in checkboxLabels) {
				height+=label.height+5;
				addChild(label);
			}
			for each (b in checkboxes) addChild(b);
		} else {
			toggleOn = false;
			for each (label in checkboxLabels) if (label.parent) removeChild(label);
			for each (b in checkboxes) if (b.parent) removeChild(b);
		}

		moreButton.setOn(showParams);

		setWidthHeight(base.width, height);
		if (parent is DialogBox) DialogBox(parent).fixLayout();
	}

	private function appendObj(o:DisplayObject):void {
		row.push(o);
		addChild(o);
		if (stage) {
			if (o is TextField) stage.focus = TextField(o);
		}
		fixLayout();
	}

	private function makeTextField(contents:String):TextField {
		var result:TextField = new TextField();
		result.borderColor = 0;
		result.backgroundColor = labelColor;
		result.background = true;
		result.type = TextFieldType.INPUT;
		result.defaultTextFormat = Block.blockLabelFormat;
		if (contents.length > 0) {
			result.width = 1000;
			result.text = contents;
			result.width = Math.max(10, result.textWidth + 2);
		} else {
			result.width = 27;
		}
		result.height = result.textHeight + 5;
		return result;
	}

	private function fixLayout(updateDelete:Boolean = true):void {
		moreButton.x = 0;
		moreButton.y = 12;

		moreLabel.x = 10;
		moreLabel.y = moreButton.y - 4;

		var labelX:int = 65;
		var buttonX:int = 66;

		var rowY:int = 35;
		for (var i:int = 0; i < checkboxes.length; i++) {
			var label:TextField = checkboxLabels[i];
			checkboxes[i].x = buttonX;
			checkboxes[i].y = rowY - 4;
			checkboxLabels[i].x = checkboxes[i].x+18;
			checkboxLabels[i].y = checkboxes[i].y-3;
			rowY += 30;
		}

		if (parent is DialogBox) DialogBox(parent).fixLayout();
	}
}}

