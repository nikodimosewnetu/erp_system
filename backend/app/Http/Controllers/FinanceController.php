<?php

namespace App\Http\Controllers;

use App\Models\Finance;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class FinanceController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): JsonResponse
    {
        $finances = Finance::where('company_id', auth()->user()->company_id)->get();
        return response()->json($finances);
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
            'type' => 'required|in:income,expense',
            'amount' => 'required|numeric|min:0',
            'description' => 'required|string|max:500',
            'date' => 'required|date',
        ]);

        $finance = Finance::create([
            'type' => $request->type,
            'amount' => $request->amount,
            'description' => $request->description,
            'date' => $request->date,
            'company_id' => auth()->user()->company_id,
        ]);

        return response()->json($finance, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Finance $finance): JsonResponse
    {
        if ($finance->company_id !== auth()->user()->company_id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }
        return response()->json($finance);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Finance $finance)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Finance $finance): JsonResponse
    {
        if ($finance->company_id !== auth()->user()->company_id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $request->validate([
            'type' => 'required|in:income,expense',
            'amount' => 'required|numeric|min:0',
            'description' => 'required|string|max:500',
            'date' => 'required|date',
        ]);

        $finance->update($request->all());
        return response()->json($finance);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Finance $finance): JsonResponse
    {
        if ($finance->company_id !== auth()->user()->company_id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $finance->delete();
        return response()->json(['message' => 'Finance record deleted successfully']);
    }
}
