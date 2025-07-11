<?php

namespace App\Http\Controllers;

use App\Models\Product;
use App\Models\Customer;
use App\Models\Order;
use App\Models\Finance;
use App\Models\Employee;
use Illuminate\Http\JsonResponse;

class DashboardController extends Controller
{
    public function index(): JsonResponse
    {
        // Get counts
        $totalProducts = Product::count();
        $totalCustomers = Customer::count();
        $totalEmployees = Employee::count();
        $totalOrders = Order::count();

        // Get financial data
        $totalRevenue = Finance::where('type', 'income')->sum('amount');
        $totalExpenses = Finance::where('type', 'expense')->sum('amount');
        $netIncome = $totalRevenue - $totalExpenses;

        // Get recent orders
        $recentOrders = Order::with('customer')
            ->orderBy('created_at', 'desc')
            ->limit(5)
            ->get();

        // Get low stock products
        $lowStockProducts = Product::with(['inventory', 'category'])
            ->whereHas('inventory', function ($query) {
                $query->whereRaw('quantity <= min_quantity');
            })
            ->limit(5)
            ->get();

        // Get top selling products (mock data for now)
        $topProducts = Product::with('category')
            ->limit(5)
            ->get()
            ->map(function ($product) {
                $product->sales_count = rand(10, 100); // Mock sales count
                return $product;
            })
            ->sortByDesc('sales_count')
            ->values();

        return response()->json([
            'success' => true,
            'data' => [
                'stats' => [
                    'total_products' => $totalProducts,
                    'total_customers' => $totalCustomers,
                    'total_employees' => $totalEmployees,
                    'total_orders' => $totalOrders,
                    'total_revenue' => $totalRevenue,
                    'total_expenses' => $totalExpenses,
                    'net_income' => $netIncome,
                ],
                'recent_orders' => $recentOrders,
                'low_stock_products' => $lowStockProducts,
                'top_products' => $topProducts,
            ],
            'message' => 'Dashboard data retrieved successfully'
        ]);
    }
} 