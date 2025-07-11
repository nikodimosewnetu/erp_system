<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\DashboardController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::post('login', [AuthController::class, 'login']);
Route::post('register', [AuthController::class, 'register']);
Route::middleware('auth:sanctum')->post('logout', [AuthController::class, 'logout']);

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::middleware('auth:sanctum')->get('profile', [AuthController::class, 'profile']);
Route::middleware('auth:sanctum')->post('change-password', [AuthController::class, 'changePassword']);

// Dashboard routes
Route::middleware('auth:sanctum')->get('dashboard', [DashboardController::class, 'index']);

// Product routes
Route::middleware('auth:sanctum')->group(function () {
    Route::apiResource('products', ProductController::class);
    Route::apiResource('customers', App\Http\Controllers\CustomerController::class);
    Route::apiResource('categories', App\Http\Controllers\CategoryController::class);
    Route::apiResource('employees', App\Http\Controllers\EmployeeController::class);
    Route::apiResource('finances', App\Http\Controllers\FinanceController::class);
    Route::apiResource('inventories', App\Http\Controllers\InventoryController::class);
    Route::apiResource('suppliers', App\Http\Controllers\SupplierController::class);
    Route::apiResource('sales-orders', App\Http\Controllers\SalesOrderController::class);
    Route::apiResource('invoices', App\Http\Controllers\InvoiceController::class);
    Route::apiResource('payments', App\Http\Controllers\PaymentController::class);
});

// TODO: Add other resource routes when controllers are created
// Route::middleware('auth:sanctum')->group(function () {
//     Route::apiResource('companies', App\Http\Controllers\CompanyController::class);
//     Route::apiResource('branches', App\Http\Controllers\BranchController::class);
//     Route::apiResource('users', App\Http\Controllers\UserController::class);
//     Route::apiResource('roles', App\Http\Controllers\RoleController::class);
// }); 