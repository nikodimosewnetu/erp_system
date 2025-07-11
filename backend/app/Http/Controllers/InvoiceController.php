<?php

namespace App\Http\Controllers;

use App\Models\Invoice;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class InvoiceController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): JsonResponse
    {
        $invoices = Invoice::with(['salesOrder'])
            ->where('company_id', auth()->user()->company_id)
            ->get();
        return response()->json($invoices);
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
            'sales_order_id' => 'required|exists:sales_orders,id',
            'invoice_date' => 'required|date',
            'due_date' => 'nullable|date',
            'total_amount' => 'required|numeric|min:0',
            'status' => 'required|in:unpaid,paid,overdue',
        ]);

        $invoice = Invoice::create([
            'sales_order_id' => $request->sales_order_id,
            'invoice_date' => $request->invoice_date,
            'due_date' => $request->due_date,
            'total_amount' => $request->total_amount,
            'status' => $request->status,
            'company_id' => auth()->user()->company_id,
        ]);
        return response()->json($invoice, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Invoice $invoice): JsonResponse
    {
        if ($invoice->company_id !== auth()->user()->company_id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }
        return response()->json($invoice->load(['salesOrder']));
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Invoice $invoice)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Invoice $invoice): JsonResponse
    {
        if ($invoice->company_id !== auth()->user()->company_id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $request->validate([
            'sales_order_id' => 'sometimes|required|exists:sales_orders,id',
            'invoice_date' => 'sometimes|required|date',
            'due_date' => 'nullable|date',
            'total_amount' => 'sometimes|required|numeric|min:0',
            'status' => 'sometimes|required|in:unpaid,paid,overdue',
        ]);

        $invoice->update($request->all());
        return response()->json($invoice);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Invoice $invoice): JsonResponse
    {
        if ($invoice->company_id !== auth()->user()->company_id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $invoice->delete();
        return response()->json(['message' => 'Invoice deleted successfully']);
    }
}
