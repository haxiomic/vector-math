/**
	TestFramework
**/

#if !macro

var _incrementingNumber: Int = 12;
function incrementingNumber() {
	return _incrementingNumber++;
}

var testsPassed = 0;
var testsFailed = 0;
var tStart_s = 0.0;
function testPassed() {
	testsPassed++;
}
function testFailed() {
	testsFailed++;
}
function testsStart() {
	tStart_s = haxe.Timer.stamp();
}
function testsComplete() {
	var dt_ms = (haxe.Timer.stamp() - tStart_s) * 1000;
	dt_ms = Math.round(dt_ms * 10000) / 10000;

	var testsTotal = testsPassed + testsFailed;
	if (testsTotal == 0) {
		println('[${TestFramework.getTargetName()}] No tests were run');
		return;
	}
	if (testsFailed == 0) {
		println('[${TestFramework.getTargetName()}] All tests passed ($testsPassed/$testsTotal) [$dt_ms ms]');
	} else {
		println('[${TestFramework.getTargetName()}] $testsFailed tests failed ($testsPassed/$testsTotal passed) [$dt_ms ms]');
	}
}

#else // if (macro) {

import haxe.macro.Context;
import haxe.macro.PositionTools;
import haxe.macro.Expr;
import haxe.macro.ComplexTypeTools;

function testInternal(expr: Expr, ?details: String) {
	var pos = Context.currentPos();
	var isBoolExpr = Context.unify(Context.typeof(expr), ComplexTypeTools.toType(macro :Bool));
	if (!isBoolExpr) {
		Context.fatalError('Test expression should be a Bool expression', pos);
	}

	var p = new haxe.macro.Printer('\t');
	var exprString = p.printExpr(expr);
	var posInfo = PositionTools.toLocation(pos);

	var binop = getFinalBinop(expr.expr);
	var valuesPrint = if (binop != null) {
		macro println(
			'\n\tResolved values:\n\n' +
			'\t' + $e{binop.e1} + '\n' +
			'\t ' + $v{p.printBinop(binop.op)} + '\n' +
			'\t' + $e{binop.e2} + '\n'
		);
	} else {
		macro null;
	}

	return macro if (!${expr}) {
		testFailed();
		var detail = $v{details};
		println(
			'Test failed (' + $v{posInfo.file} + ':' + $v{posInfo.range.start.line} + ')\n\n' +
			(detail != null ? '\t' + detail + '\n' : '') +
			$v{exprString.split('\n').map(l -> '\t' + l).join('\n')}
		);
		$valuesPrint;
	} else {
		testPassed();
	};
}

function getFinalBinop(expr) {
	return switch expr {
		case EBinop(op, e1, e2): { op: op, e1: e1, e2: e2 };
		// case EBlock(exprs): getFinalBinop(exprs[exprs.length - 1].expr);
		default: null;
	}
}

#end

macro function test(expr: haxe.macro.Expr, ?details: String) {
	return testInternal(expr, details);
}

/** assumes a function named limitPrecision() is available in the calling scope **/
macro function testLimitedPrecision(expr: haxe.macro.Expr, ?details: String) {
	return testInternal(
		switch expr {
			case {expr: EBinop(op, e1, e2), pos: pos}: {
				expr: EBinop(op, macro limitPrecision($e1), macro limitPrecision($e2)),
				pos: pos,
			}
			default: Context.error('Expected binary op expression', Context.currentPos());
		},
		details
	);
}

macro function getTargetName() {
	return macro $v{haxe.macro.Context.definedValue('target.name')};
}

function println(str) {
	#if sys
	Sys.println(str);
	#elseif js
	js.Browser.console.log(str);
	#else
	trace(str);
	#end
}