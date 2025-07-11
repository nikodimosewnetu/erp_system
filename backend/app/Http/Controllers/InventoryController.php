<?php

namespace App\Http\Controllers;

use App\Models\Inventory;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class InventoryController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): JsonResponse
    {
        $inventories = Inventory::with(['product', 'branch'])->get();
        return response()->json($inventories);
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
            'product_id' => 'required|exists:products,id',
            'branch_id' => 'required|exists:branches,id',
            'quantity' => 'required|integer|min:0',
            'min_stock' => 'nullable|integer|min:0',
            'max_stock' => 'nullable|integer|min:0',
        ]);

        $inventory = Inventory::create($request->all());
        return response()->json($inventory, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Inventory $inventory): JsonResponse
    {
        return response()->json($inventory->load(['product', 'branch']));
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Inventory $inventory)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Inventory $inventory): JsonResponse
    {
        $request->validate([
            'product_id' => 'sometimes|required|exists:products,id',
            'branch_id' => 'sometimes|required|exists:branches,id',
            'quantity' => 'sometimes|required|integer|min:0',
            'min_stock' => 'nullable|integer|min:0',
            'max_stock' => 'nullable|integer|min:0',
        ]);

        $inventory->update($request->all());
        return response()->json($inventory);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Inventory $inventory): JsonResponse
    {
        $inventory->delete();
        return response()->json(['message' => 'Inventory record deleted successfully']);
    }
}
