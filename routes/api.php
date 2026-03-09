<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Response;
use Illuminate\Support\Facades\Route;

Route::get('/user', static function (Request $request) {
	return $request->user();
})->middleware('auth:sanctum');

Route::get('/welcome', static function (Request $request) {
	return Response::json([
		'success' => true,
		'message' => 'Hello world!!!'
	]);
});