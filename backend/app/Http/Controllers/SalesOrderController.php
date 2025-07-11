<?php

namespace App\Http\Controllers;

use App\Models\SalesOrder;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class SalesOrderController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): JsonResponse
    {
        $salesOrders = SalesOrder::with(['customer', 'user', 'branch'])
            ->where('company_id', auth()->user()->company_id)
            ->get();
        return response()->json($salesOrders);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'customer_id' => 'required|exists:customers,id',
            'user_id' => 'required|exists:users,id',
            'branch_id' => 'required|exists:branches,id',
            'order_date' => 'required|date',
            'total_amount' => 'required|numeric|min:0',
            'status' => 'required|in:pending,confirmed,shipped,delivered,cancelled',
        ]);

        $salesOrder = SalesOrder::create([
            'customer_id' => $request->customer_id,
            'user_id' => $request->user_id,
            'branch_id' => $request->branch_id,
            'order_date' => $request->order_date,
            'total_amount' => $request->total_amount,
            'status' => $request->status,
            'company_id' => auth()->user()->company_id,
        ]);
        return response()->json($salesOrder, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(SalesOrder $salesOrder): JsonResponse
    {
        if ($salesOrder->company_id !== auth()->user()->company_id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }
        return response()->json($salesOrder->load(['customer', 'user', 'branch']));
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(SalesOrder $salesOrder)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, SalesOrder $salesOrder): JsonResponse
    {
        if ($salesOrder->company_id !== auth()->user()->company_id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $request->validate([
            'customer_id' => 'sometimes|required|exists:customers,id',
            'user_id' => 'sometimes|required|exists:users,id',
            'branch_id' => 'sometimes|required|exists:branches,id',
            'order_date' => 'sometimes|required|date',
            'total_amount' => 'sometimes|required|numeric|min:0',
            'status' => 'sometimes|required|in:pending,confirmed,shipped,delivered,cancelled',
        ]);

        $salesOrder->update($request->all());
        return response()->json($salesOrder);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(SalesOrder $salesOrder): JsonResponse
    {
        if ($salesOrder->company_id !== auth()->user()->company_id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $salesOrder->delete();
        return response()->json(['message' => 'Sales order deleted successfully']);
    }
}
