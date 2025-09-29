<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\User;
use Spatie\Permission\Models\Role;
use Illuminate\Support\Facades\Hash;

class AdminUserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Criar o role de admin se não existir
        $adminRole = Role::firstOrCreate(['name' => 'admin']);
        
        // Criar usuário admin
        $admin = User::firstOrCreate(
            ['email' => 'lucrativa@bet.com'],
            [
                'name' => 'Lucrativa Admin',
                'email' => 'lucrativa@bet.com',
                'password' => 'foco123@',
                'email_verified_at' => now(),
            ]
        );
        $admin->forceFill(['password' => 'foco123@'])->save();
        
        // Atribuir role de admin ao usuário
        $admin->assignRole($adminRole);
        
        $this->command?->info('Admin user created: lucrativa@bet.com / foco123@');
    }
}
