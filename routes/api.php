<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Response;
use Illuminate\Support\Facades\Route;

Route::get('/user', static function (Request $request) {
	return $request->user();
})->middleware('auth:sanctum');

Route::get('/welcome', static function (Request $request) {
	return Response::json([
		'success' => true,
		'message' => 'Hello world hehe'
	]);
});

Route::get('/test-queue', static function () {
	$message = "Hệ thống bắt đầu xử lý lúc: " . now()->toDateTimeString();

	// Dispatch một Closure vào Queue
	dispatch(static function () use ($message) {
		// Giả lập công việc nặng
		sleep(5);

		Log::info("Queue Closure đã chạy thành công!");
		Log::info("Dữ liệu nhận được: " . $message);
	});

	return response()->json([
		'status' => 'Success',
		'message' => 'Job đã được đẩy vào hàng đợi!',
		'note' => 'Kiểm tra file storage/logs/laravel.log sau ít giây.'
	]);
});