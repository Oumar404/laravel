<?php

use Illuminate\Support\Facades\Route;

// Health check endpoint for Kubernetes
Route::get('/healthz', function () {
    return response()->json(['status' => 'ok']);
});

// SPA Vue en page d'accueil et fallback
Route::view('/', 'app');
Route::view('/{any}', 'app')->where('any', '.*');
