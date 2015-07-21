GL_STATUS = {
  :credit => 1, 
  :debit => 2 
}


ACCOUNT_GROUP = {
  :asset => 1,
  :expense => 2, 
  :liability => 3, 
  :revenue => 4, 
  :equity => 5 
  
}



NORMAL_BALANCE = {
  :debit => 1 , 
  :credit => 2 
}

ACCOUNT_CASE = {
  :group => 1,  # group => can't create transaction on group_account
  # group account can have sub_groups and ledger_account 
  :ledger => 2  # ledger_account is where the journal is associated to
} 
 


ACCOUNT_CODE = {
  :aktiva => {
    :code => "1",
    :name => "AKTIVA",
    :normal_balance => 1,
    :status => 1,
    :parent_code => nil
  },
  :aktiva_lancar => {
    :code => "11",
    :name => "AKTIVA LANCAR",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "1"
  },
  :kas_dan_setara_kas => {
    :code => "1101",
    :name => "KAS DAN SETARA KAS",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "11"
  },
  :kas_dan_bank  => {
    :code => "110101",
    :name => "KAS DAN BANK",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "1101"
  },
  :piutang_usaha_level_1  => {
    :code => "1103",
    :name => "PIUTANG USAHA",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "11"
  },
  :piutang_usaha_level_2  => {
    :code => "110301",
    :name => "PIUTANG USAHA",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "1103"
    },  
  :piutang_lain_lain_level_1  => {
    :code => "1104",
    :name => "PIUTANG LAIN-LAIN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "11"
    },
  :piutang_lain_lain_level_2  => {
    :code => "110401",
    :name => "PIUTANG LAIN-LAIN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "1104"
    },
  :piutang_lainnya  => {
    :code => "11040103",
    :name => "PIUTANG LAINNYA",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "110401"
    },
  :piutang_gbch  => {
    :code => "110402",
    :name => "PIUTANG GBCH",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "1104"
    },
  :persediaan_barang_level_1  => {
    :code => "1105",
    :name => "PERSEDIAAN BARANG",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "11"
    },
  :persediaan_barang_level_2  => {
    :code => "110501",
    :name => "PERSEDIAAN BARANG",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "1105"
    },
  :persediaan_printing_chemicals  => {
    :code => "11050001",
    :name => "PERSED. PRINTING CHEMICALS",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "1105"
    },
  :persediaan_printing_blanket  => {
    :code => "11050002",
    :name => "PERSED. PRINTING BLANKET",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "1105"
    },  
  :persediaan_printing_rollers  => {
    :code => "11050003",
    :name => "PERSED. PRINTING ROLLERS",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "1105"
    },
  :persediaan_barang_lainnya  => {
    :code => "11050004",
    :name => "PERSED. BARANG LAINNYA",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "1105"
    },
  :bahan_baku_blanket  => {
    :code => "11050102",
    :name => "BAHAN BAKU BLANKET",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "1105"
    },
  :bahan_baku_rollers  => {
    :code => "11050103",
    :name => "BAHAN BAKU ROLLERS",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "1105"
    },
  :bahan_baku_other  => {
    :code => "11050104",
    :name => "BAHAN BAKU OTHER",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "1105"
    },
  :uang_muka_pembelian_level_1  => {
    :code => "1106",
    :name => "UANG MUKA PEMBELIAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "11"
    },
  :uang_muka_pembelian_level_2 => {
    :code => "110601",
    :name => "UANG MUKA PEMBELIAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "1106"
    },
  :uang_muka_pembelian_lokal => {
    :code => "11060001",
    :name => "UANG MUKA PEMBELIAN LOKAL",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "110601"
    },
  :uang_muka_pembelian_impor => {
    :code => "11060002",
    :name => "UANG MUKA PEMBELIAN IMPOR",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "110601"
    },
  :uang_muka_lainnya => {
    :code => "11060003",
    :name => "UANG MUKA PEMBELIAN LAINNYA",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "110601"
    },
  :pajak_dibayar_di_muka_level_1 => {
    :code => "1107",
    :name => "PAJAK DIBAYAR DI MUKA",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "11"
    },
  :pajak_dibayar_di_muka_level_2 => {
    :code => "110701",
    :name => "PAJAK DIBAYAR DI MUKA",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "1107"
    },
  :pph_ps_23 => {
    :code => "11070002",
    :name => "PPH PS 23",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "110701"
    },
  :ppn_masukan => {
    :code => "11070004",
    :name => "PPN MASUKAN",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "110701"
    },
  :beban_usaha => {
    :code => "2",
    :name => "BEBAN USAHA",
    :normal_balance => 1,
    :status => 1,
    :parent_code => nil
    },  
  :biaya_administrasi_dan_umum => {
    :code => "62",
    :name => "BIAYA ADMINISTRASI & UMUM",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "2"
    },
  :biaya_operasional_kantor_level_1 => {
    :code => "6202",
    :name => "BIAYA OPERASIONAL KANTOR",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "62"
    },
  :biaya_operasional_kantor_level_2 => {
    :code => "620201",
    :name => "BIAYA OPERASIONAL KANTOR",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "6202"
    },
  :biaya_pembulatan => {
    :code => "62020014",
    :name => "BIAYA PEMBULATAN",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620201"
    },
  :biaya_penyusutan_amortisasi => {
    :code => "6208",
    :name => "BY. PENYUSUTAN AMORTISASI",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "62"
    },
  :biaya_keuangan_level_1 => {
    :code => "6209",
    :name => "BIAYA KEUANGAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "62"
    },
  :biaya_keuangan_level_2 => {
    :code => "620901",
    :name => "BIAYA KEUANGAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "6209"
    },
  :biaya_bunga_bank => {
    :code => "62090001",
    :name => "BIAYA BUNGA BANK",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620901"
    },
  :biaya_administrasi_bank => {
    :code => "62090002",
    :name => "BIAYA ADMINISTRASI BANK",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620901"
    },  
  :beban_lain_lain_level_1 => {
    :code => "72",
    :name => "BEBAN LAIN LAIN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "2"
    },
  
  :beban_lain_lain_level_2 => {
    :code => "7201",
    :name => "BEBAN LAIN-LAIN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "72"
    },   
  :beban_lain_lain_level_3 => {
    :code => "720101",
    :name => "BEBAN LAIN-LAIN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "7201"
    },  
  :rugi_selisih_kurs => {
    :code => "72010001",
    :name => "RUGI SELISIH KURS",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "720101"
    }, 
  :beban_non_operasional_level_1 => {
    :code => "7202",
    :name => "BEBAN NON OPERASIONAL",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "72"
    },
    
  :beban_non_operasional_level_2 => {
    :code => "720201",
    :name => "BEBAN NON OPERASIONAL",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "7202"
    },
  :laba_penjualan_aktiva_tetap => {
    :code => "72020001",
    :name => "LABA PENJUALAN AKTIVA TETAP",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "720201"
    },  
 
  :passiva => {
    :code => "3",
    :name => "PASSIVA",
    :normal_balance => 1,
    :status => 1,
    :parent_code => nil
    },  
  :kewajiban_lancar => {
    :code => "21",
    :name => "KEWAJIBAN LANCAR",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "3"
    },
  :hutang_lain_Lain => {
    :code => "2103",
    :name => "HUTANG LAIN-LAIN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "21"
    },  
  :hutang_usaha_level_1 => {
    :code => "2102",
    :name => "HUTANG USAHA",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "21"
    }, 
  :hutang_usaha_level_2 => {
    :code => "210201",
    :name => "HUTANG USAHA",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "2102"
    },  
  :hutang_pembelian_lainnya => {
    :code => "21020003",
    :name => "HUTANG PEMBELIAN LAINNYA",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "210201"
    },  
  :hutang_lainnya => {
    :code => "21030002",
    :name => "HUTANG LAINNYA",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "210201"
    },  
  :hutang_gbch => {
    :code => "210302",
    :name => "HUTANG GBCH",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "2103"
    },  
  :hutang_pajak_level_1 => {
    :code => "2105",
    :name => "HUTANG PAJAK",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "21"
    },
  :hutang_pajak_level_2 => {
    :code => "210501",
    :name => "HUTANG PAJAK",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "2105"
    },
  :hutang_pph_ps_21 => {
    :code => "21050001",
    :name => "HUTANG PPH PS 21",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "210501"
    },  
  :hutang_pph_ps_23 => {
    :code => "21050002",
    :name => "HUTANG PPH PS 23",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "210501"
    }, 
  :ppn_keluaran => {
    :code => "21050007",
    :name => "PPN KELUARAN",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "210501"
    },
 
  :modal_level_1 => {
    :code => "4",
    :name => "MODAL",
    :normal_balance => 2,
    :status => 1,
    :parent_code => nil
    },
  :modal_level_2 => {
    :code => "31",
    :name => "MODAL",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "4"
    },
  :laba_rugi_bulan_berjalan_level_1 => {
    :code => "3104",
    :name => "LABA/RUGI BULAN BERJALAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "31"
    },
  :laba_rugi_bulan_berjalan_level_2 => {
    :code => "310401",
    :name => "LABA/RUGI BULAN BERJALAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "3104"
    },
  :laba_rugi_bulan_berjalan_level_3 => {
    :code => "31040001",
    :name => "LABA/RUGI BULAN BERJALAN",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "310401"
    },
  :dividen_level_1 => {
    :code => "3105",
    :name => "DIVIDEN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "31"
    },
  :dividen_level_2 => {
    :code => "310501",
    :name => "DIVIDEN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "3105"
    },
  :dividen_level_3 => {
    :code => "31050001",
    :name => "DIVIDEN",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "310501"
    },
  :penyesuaian_modal_level_1 => {
    :code => "3109",
    :name => "PENYESUAIAN MODAL",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "31"
    },
  :penyesuaian_modal_level_2 => {
    :code => "310901",
    :name => "PENYESUAIAN MODAL",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "3109"
    },
  :penyesuaian_modal_level_3 => {
    :code => "31090001",
    :name => "PENYESUAIAN MODAL",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "310901"
    },
  :harga_pokok => {
    :code => "51",
    :name => "HARGA POKOK",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "2"
    }, 
  :harga_pokok_penjualan_level_1 => {
    :code => "5101",
    :name => "HARGA POKOK PENJUALAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "51"
    },  
  :harga_pokok_penjualan_level_2 => {
    :code => "510101",
    :name => "HARGA POKOK PENJUALAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "5101"
    },  
  :harga_pokok_penjualan_level_3 => {
    :code => "51010001",
    :name => "HARGA POKOK PENJUALAN",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "510101"
    },
  :potongan_pembelian => {
    :code => "51010002",
    :name => "POTONGAN PEMBELIAN",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "510101"
    },
  :biaya_overhead_pabrik_level_1 => {
    :code => "5102",
    :name => "BIAYA OVERHEAD PABRIK",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "51"
    },
  :biaya_overhead_pabrik_level_2 => {
    :code => "510201",
    :name => "BIAYA OVERHEAD PABRIK",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "5102"
    },
  :biaya_overhead_pabrik_level_3 => {
    :code => "51020001",
    :name => "BIAYA OVERHEAD PABRIK",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "510201"
    },
  :pendapatan_bunga_deposito => {
    :code => "71010002",
    :name => "PENDAPATAN BUNGA DEPOSITO",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "710101"
    },
  :pendapatan_jasa_giro => {
    :code => "71010001",
    :name => "PENDAPATAN JASA GIRO",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "710101"
    },
  :pendapatan_bunga_level_2 => {
    :code => "710101",
    :name => "PENDAPATAN BUNGA",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "7101"
    },
  :pendapatan_bunga_level_1 => {
    :code => "7101",
    :name => "PENDAPATAN BUNGA",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "71"
    },
  :pendapatan_level_1 => {
    :code => "5",
    :name => "PENDAPATAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => nil
    },
  :pendapatan_level_2 => {
    :code => "41",
    :name => "PENDAPATAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "5"
    },
  :pendapatan_penjualan_level_1 => {
    :code => "4101",
    :name => "PENDAPATAN PENJUALAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "41"
    },
  :pendapatan_penjualan_level_2 => {
    :code => "410101",
    :name => "PENDAPATAN PENJUALAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "4101"
    },
  :pendapatan_penjualan_level_3 => {
    :code => "41010001", 
    :name => "PENDAPATAN PENJUALAN",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "410101"
    },
  :pendapatan_lain_lain => {
    :code => "71",
    :name => "PENDAPATAN LAIN-LAIN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "5"
    },
  :pendapatan_lainnya_level_1 => {
    :code => "7102",
    :name => "PENDAPATAN LAINNYA",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "71"
    },
  :pendapatan_lainnya_level_2 => {
    :code => "710201",
    :name => "PENDAPATAN LAINNYA",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "7102"
    },
  :pendapatan_selisih_kurs => {
    :code => "71020001",
    :name => "PENDAPATAN SELISIH KURS",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "710201"
    },
  
  }
   
  TRANSACTION_DATA_CODE = {
    :cash_bank_adjustment_journal => 10,
    :cash_bank_mutation_journal => 20, 
    :purchase_receival_journal => 30, 
    :purchase_invoice_journal => 40 ,
    :payment_voucher_journal => 50 ,
    :payment_request_journal => 60, 
    :delivery_order_journal => 70 ,
    :sales_invoice_journal => 80 ,  
    :receipt_voucher_journal => 90, 
    :closing_journal => 100, 
    :blanket_order_detail_journal_finish => 110  ,
    :blending_work_order_journal => 120, 
    :sales_invoice_migration_journal => 130, 
    :purchase_invoice_migration_journal => 140, 
    :bank_administration_journal => 150,
    :memorial_journal => 160,
    :virtual_order_clearance_journal => 170,
    :sales_down_payment_journal => 180,
    :purchase_down_payment_journal => 190,
    :sales_down_payment_allocation_journal  => 200,
    :purchase_down_payment_allocation_journal  => 210,

    :savings_account => 220,
    :membership_savings_account => 230,
    :locked_savings_account => 240,
    :memorial_general => 250
  
  
}