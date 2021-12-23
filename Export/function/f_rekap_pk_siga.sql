CREATE OR REPLACE FUNCTION sigabaru.f_rekap_pk_siga(v_bulan integer, v_tahun integer, v_nik character varying, v_nama character varying, v_id_propinsi integer, v_id_kabupaten integer, v_id_kecamatan integer, v_id_kelurahan integer, v_id_rw integer, v_id_rt integer, v_kesertaan_jkn boolean, v_status_pus boolean, v_status_hamil boolean, v_metode_kontrasepsi character varying, v_jalur_pelayanan character varying, v_ingin_anak_segera boolean, v_ingin_anak_kemudian boolean, v_tidak_ingin_anak_lagi boolean, v_keluarga_sasaran_bkb boolean, v_kesertaan_bkb boolean, v_keluarga_sasaran_bkr boolean, v_kesertaan_bkr boolean, v_keluarga_sasaran_bkl boolean, v_kesertaan_bkl boolean, v_uppks_kesertaan boolean, v_offset integer, v_limit integer)
 RETURNS TABLE(kki text, nik text, nama text, hubungan_dengan_kk text, tanggal_lahir date, usia integer, no_telepon text, alamat text, jumlah_anak integer, kesertaan_jkn boolean, status_pus boolean, status_hamil boolean, metode_kontrasepsi text, jalur_pelayanan text, ingin_anak_segera boolean, ingin_anak_kemudian boolean, tidak_ingin_anak_lagi boolean, keluarga_sasaran_bkb boolean, kesertaan_bkb boolean, keluarga_sasaran_bkr boolean, kesertaan_bkr boolean, keluarga_sasaran_bkl boolean, kesertaan_bkl boolean, lama_ber_kb text, uppks_kesertaan boolean, mutasi text, id_provinsi integer, id_kabupaten integer, id_kecamatan integer, id_kelurahan integer, id_rw integer, id_rt integer, kesertaan_berkb text, status_peserta_kb text, bulan_kapan_mulai integer, tahun_kapan_mulai integer, bulan_kapan_berhenti integer, tahun_kapan_berhenti integer, sumber_data text, jumlah_balita integer, jumlah_remaja integer, jumlah_lansia integer, mutasi_individu character varying, tgl_mutasi_individu timestamp without time zone, mutasi_keluarga character varying, tgl_mutasi_keluarga timestamp without time zone)
 LANGUAGE plpgsql
AS $function$
begin
	return query
		SELECT COALESCE(COALESCE(rek.kki, pk.kki), bkb.kki)::text AS kki,
            COALESCE(COALESCE(rek.nik, pk.nik), bkb.nik)::text AS nik,
            COALESCE(COALESCE(rek.nama, pk.nama), bkb.nama)::text AS nama,
            COALESCE(COALESCE(rek.hubungan_dengan_kk, pk.hubungan_dengan_kk::character varying), 'KK')::text AS hubungan_dengan_kk,
            COALESCE(rek.tanggal_lahir, pk.tanggal_lahir) as tanggal_lahir,
            COALESCE(rek.usia, pk.usia)::int as usia,
            COALESCE(rek.no_telepon, pk.no_telepon)::text as no_telepon,
            COALESCE(rek.alamat, pk.alamat)::text as alamat,
            COALESCE(rek.jumlah_anak, pk.jumlah_anak)::int as jumlah_anak,
            COALESCE(rek.kesertaan_jkn, pk.kesertaan_jkn) as kesertaan_jkn,
            COALESCE(rek.status_pus, pk.status_pus) as status_pus,
            COALESCE(rek.status_hamil, pk.status_hamil) as status_hamil,
            (case when bkb.created_date > rek.created_date then bkb.metode_kontrasepsi
            	else COALESCE(COALESCE(rek.metode_kontrasepsi, pk.metode_kontrasepsi::character varying), bkb.metode_kontrasepsi::character varying) 
            end)::text AS metode_kontrasepsi,
            (case when bkb.created_date > rek.created_date then bkb.jalur_pelayanan
            	else COALESCE(COALESCE(rek.jalur_pelayanan, pk.jalur_pelayanan::character varying), bkb.jalur_pelayanan::character varying) 
            end)::text AS jalur_pelayanan,
            COALESCE(rek.ingin_anak_segera, pk.ingin_anak_segera) as ingin_anak_segera,
            COALESCE(rek.ingin_anak_kemudian, pk.ingin_anak_kemudian) as ingin_anak_kemudian,
            COALESCE(rek.tidak_ingin_anak_lagi, pk.tidak_ingin_anak_lagi) as tidak_ingin_anak_lagi,
            COALESCE(rek.keluarga_sasaran_bkb, pk.keluarga_sasaran_bkb) as keluarga_sasaran_bkb,
            case when bkb.created_date > rek.created_date then bkb.kesertaan_bkb
            	else COALESCE(COALESCE(rek.kesertaan_bkb, pk.kesertaan_bkb), bkb.kesertaan_bkb) 
            end AS kesertaan_bkb,
            COALESCE(rek.keluarga_sasaran_bkr, pk.keluarga_sasaran_bkr) as keluarga_sasaran_bkr,
            case when bkb.created_date > rek.created_date then bkb.kesertaan_bkr
            	else COALESCE(COALESCE(rek.kesertaan_bkr, pk.kesertaan_bkr), bkb.kesertaan_bkr) 
            end AS kesertaan_bkr,
            COALESCE(rek.keluarga_sasaran_bkl, pk.keluarga_sasaran_bkl) as keluarga_sasaran_bkl,
            case when bkb.created_date > rek.created_date then bkb.kesertaan_bkl
            	else COALESCE(COALESCE(rek.kesertaan_bkl, pk.kesertaan_bkl), bkb.kesertaan_bkl) 
            end AS kesertaan_bkl,
            COALESCE(rek.lama_ber_kb, pk.lama_ber_kb)::text as lama_ber_kb,
            case when bkb.created_date > rek.created_date then bkb.uppks_kesertaan
            	else COALESCE(COALESCE(rek.uppks_kesertaan, pk.uppks_kesertaan), bkb.uppks_kesertaan) 
            end as uppks_kesertaan,
            COALESCE(rek.mutasi, pk.mutasi)::text as mutasi,
            COALESCE(rek.id_provinsi, pk.id_provinsi) as id_provinsi,
            COALESCE(rek.id_kabupaten, pk.id_kabupaten) as id_kabupaten,
            COALESCE(rek.id_kecamatan, pk.id_kecamatan) as id_kecamatan,
            COALESCE(rek.id_kelurahan, pk.id_kelurahan) as id_kelurahan,
            COALESCE(rek.id_rw, pk.id_rw) as id_rw,
            COALESCE(rek.id_rt, pk.id_rt) as id_rt,
            COALESCE(rek.kesertaan_berkb, pk.kesertaan_berkb)::text as kesertaan_berkb,
            (case when bkb.created_date > rek.created_date then bkb.status_peserta_kb
            	else coalesce(coalesce(rek.status_peserta_kb, pk.status_peserta_kb), bkb.status_peserta_kb) 
            end)::text as status_peserta_kb,
			COALESCE(rek.bulan_kapan_mulai, pk.bulan_kapan_mulai) as bulan_kapan_mulai,
			COALESCE(rek.tahun_kapan_mulai, pk.tahun_kapan_mulai) as tahun_kapan_mulai,
			COALESCE(rek.bulan_kapan_berhenti, pk.bulan_kapan_berhenti) as bulan_kapan_berhenti,
			COALESCE(rek.tahun_kapan_berhenti, pk.tahun_kapan_berhenti) as tahun_kapan_berhenti,
			case when rek.kki is not null or rek.created_date is not null then 'REKAP'
				else coalesce(bkb.sumber_data, pk.sumber_data) 
			end as sumber_data,
			COALESCE(rek.jumlah_balita, pk.jumlah_balita)::int as jumlah_balita,
			COALESCE(rek.jumlah_remaja, pk.jumlah_remaja)::int as jumlah_remaja,
			COALESCE(rek.jumlah_lansia, pk.jumlah_lansia)::int as jumlah_lansia,
			(case when rek.id_mutasi_individu = 1 then 'MENIKAH'
				when rek.id_mutasi_individu = 2 then 'BERCERAI'
				when rek.id_mutasi_individu = 3 then 'MENINGGAL DUNIA'
				when rek.id_mutasi_individu = 4 then 'ANGGOTA KELUARGA BARU'
				when rek.id_mutasi_individu = 5 then 'PINDAH'
			else rek.id_mutasi_individu::varchar end)::varchar as mutasi_individu,
			rek.tgl_mutasi_individu,
			(case when rek.id_mutasi_keluarga = 1 then 'PINDAH KELUARGA'
				when rek.id_mutasi_keluarga = 2 then 'KELUARGA BARU'
			else rek.id_mutasi_keluarga::varchar end)::varchar as mutasi_keluarga,
			rek.tgl_mutasi_keluarga
           FROM 
             ------- << source Rekap >> -------
           	 (select hd.kki
				,di.nik
				,di.nama
				,di.hubungan_dengan_kk
				,di.tanggal_lahir
				,to_char(age(now(), di.tanggal_lahir::timestamp with time zone), 'YYYY'::text)::integer as usia
				,hd.no_telepon
				,hd.alamat
				,dk.jumlah_anak
				,dk.kesertaan_jkn
				,case when to_char(age(now(), dk.tgl_lahir_istri::timestamp with time zone), 'YYYY'::text)::integer >= 15 AND to_char(age(now(), dk.tgl_lahir_istri::timestamp with time zone), 'YYYY'::text)::integer <= 49 THEN true
				else false end as status_pus
				,dk.status_hamil
				,dk.metode_kontrasepsi
				,dk.jalur_pelayanan
				,dk.ingin_anak_segera
				,dk.ingin_anak_kemudian
				,dk.tidak_ingin_anak_lagi
				,case when to_char(age(now(), dk.tgl_lahir_balita::timestamp with time zone), 'YYYY'::text)::integer >= 0 AND to_char(age(now(), dk.tgl_lahir_balita::timestamp with time zone), 'YYYY'::text)::integer <= 6 then true
				else false end as keluarga_sasaran_bkb
				,dk.kesertaan_bkb
				,case when to_char(age(now(), dk.tgl_lahir_remaja::timestamp with time zone), 'YYYY'::text)::integer >= 10 AND to_char(age(now(), dk.tgl_lahir_remaja::timestamp with time zone), 'YYYY'::text)::integer <= 24 then true
				else false end as keluarga_sasaran_bkr
				,dk.kesertaan_bkr
				,case when to_char(age(now(), dk.tgl_lahir_lansia::timestamp with time zone), 'YYYY'::text)::integer >= 60 then true
				else false end as keluarga_sasaran_bkl
				,dk.kesertaan_bkl
				,hd.id_provinsi
				,hd.id_kabupaten
				,hd.id_kecamatan
				,hd.id_kelurahan
				,hd.id_rw
				,hd.id_rt
				,dk.lama_ber_kb
				,dk.uppks_kesertaan
				,dk.mutasi
				,coalesce(di.created_date, hd.created_date ) as created_date
				,dk.kesertaan_berkb
				,dk.status_peserta_kb
				,dk.bulan_kapan_mulai
				,dk.tahun_kapan_mulai
				,dk.bulan_kapan_berhenti
				,dk.tahun_kapan_berhenti
				,dk.jumlah_balita
				,dk.jumlah_remaja
				,dk.jumlah_lansia
				,di.id_mutasi_individu
				,di.tgl_mutasi_individu
				,hd.id_mutasi_keluarga
				,hd.tgl_mutasi_keluarga
			from sigabaru.rekap_pk_siga_head hd
			left join sigabaru.rekap_pk_siga_dtl_individu di
			on hd.id_rekap = di.id_rekap
			left join (select * from (
					select a.*,
						lead(a.id_rekap) OVER (PARTITION BY a.id_rekap ORDER BY a.created_date) as flag
					from sigabaru.rekap_pk_siga_dtl_keluarga a
					WHERE --a.bulan_rekap <= COALESCE(v_bulan, to_char(now(), 'MM'::text)::integer)
--					AND a.tahun_rekap <= COALESCE(v_tahun, to_char(now(), 'YYYY'::text)::integer)
					concat(a.tahun_rekap::varchar, lpad(a.bulan_rekap::varchar,2,'0')) <= coalesce(concat(v_tahun::varchar, lpad(v_bulan::varchar,2,'0')), to_char(now(), 'YYYYMM'))
					) b
				where b.flag is null) dk
			on hd.id_rekap = dk.id_rekap
			where (v_nik is null
				and hd.id_provinsi = coalesce(v_id_propinsi, hd.id_provinsi)
			    and hd.id_kabupaten = coalesce(v_id_kabupaten, hd.id_kabupaten)
			    and hd.id_kecamatan = coalesce(v_id_kecamatan, hd.id_kecamatan)
			    and hd.id_kelurahan = coalesce(v_id_kelurahan, hd.id_kelurahan)
			    and hd.id_rw = coalesce(v_id_rw, hd.id_rw)
			    and hd.id_rt = coalesce(v_id_rt, hd.id_rt)
			    and upper(di.nama) like '%' || upper(coalesce(v_nama, di.nama)) || '%'
				and upper(di.hubungan_dengan_kk) = 'KK'
				and coalesce(dk.kesertaan_jkn::text, '-') = coalesce(v_kesertaan_jkn::text, coalesce(dk.kesertaan_jkn::text, '-'))
			    and coalesce((case when to_char(age(now(), dk.tgl_lahir_istri::timestamp with time zone), 'YYYY'::text)::integer >= 15 AND to_char(age(now(), dk.tgl_lahir_istri::timestamp with time zone), 'YYYY'::text)::integer <= 49 THEN true else false end)::text, '-') 
			    = coalesce(v_status_pus::text, coalesce((case when to_char(age(now(), dk.tgl_lahir_istri::timestamp with time zone), 'YYYY'::text)::integer >= 15 AND to_char(age(now(), dk.tgl_lahir_istri::timestamp with time zone), 'YYYY'::text)::integer <= 49 THEN true else false end)::text, '-'))
			    and coalesce(dk.status_hamil::text, '-') = coalesce(v_status_hamil::text, coalesce(dk.status_hamil::text, '-'))
			    and coalesce(dk.metode_kontrasepsi, '-') = coalesce(v_metode_kontrasepsi, coalesce(dk.metode_kontrasepsi, '-'))
			    and coalesce(dk.jalur_pelayanan, '-') = coalesce(v_jalur_pelayanan, coalesce(dk.jalur_pelayanan, '-'))
			    and coalesce(dk.ingin_anak_segera::text, '-') = coalesce(v_ingin_anak_segera::text, coalesce(dk.ingin_anak_segera::text, '-'))
			    and coalesce(dk.ingin_anak_kemudian::text, '-') = coalesce(v_ingin_anak_kemudian::text, coalesce(dk.ingin_anak_kemudian::text, '-'))
			    and coalesce(dk.tidak_ingin_anak_lagi::text, '-') = coalesce(v_tidak_ingin_anak_lagi::text, coalesce(dk.tidak_ingin_anak_lagi::text, '-'))
			    and coalesce((case when to_char(age(now(), dk.tgl_lahir_balita::timestamp with time zone), 'YYYY'::text)::integer >= 0 AND to_char(age(now(), dk.tgl_lahir_balita::timestamp with time zone), 'YYYY'::text)::integer <= 6 then true else false end)::text, '-') 
			    = coalesce(v_keluarga_sasaran_bkb::text, coalesce((case when to_char(age(now(), dk.tgl_lahir_balita::timestamp with time zone), 'YYYY'::text)::integer >= 0 AND to_char(age(now(), dk.tgl_lahir_balita::timestamp with time zone), 'YYYY'::text)::integer <= 6 then true else false end)::text, '-'))
			    and coalesce(dk.kesertaan_bkb::text, '-') = coalesce(v_kesertaan_bkb::text, coalesce(dk.kesertaan_bkb::text, '-'))
			    and coalesce((case when to_char(age(now(), dk.tgl_lahir_remaja::timestamp with time zone), 'YYYY'::text)::integer >= 10 AND to_char(age(now(), dk.tgl_lahir_remaja::timestamp with time zone), 'YYYY'::text)::integer <= 24 then true else false end)::text, '-') 
			    = coalesce(v_keluarga_sasaran_bkr::text, coalesce((case when to_char(age(now(), dk.tgl_lahir_remaja::timestamp with time zone), 'YYYY'::text)::integer >= 10 AND to_char(age(now(), dk.tgl_lahir_remaja::timestamp with time zone), 'YYYY'::text)::integer <= 24 then true else false end)::text, '-'))
			    and coalesce(dk.kesertaan_bkr::text, '-') = coalesce(v_kesertaan_bkr::text, coalesce(dk.kesertaan_bkr::text, '-'))
			    and coalesce((case when to_char(age(now(), dk.tgl_lahir_lansia::timestamp with time zone), 'YYYY'::text)::integer >= 60 then true else false end)::text, '-') 
			    = coalesce(v_keluarga_sasaran_bkl::text, coalesce((case when to_char(age(now(), dk.tgl_lahir_lansia::timestamp with time zone), 'YYYY'::text)::integer >= 60 then true else false end)::text, '-'))
			    and coalesce(dk.kesertaan_bkl::text, '-') = coalesce(v_kesertaan_bkl::text, coalesce(dk.kesertaan_bkl::text, '-'))
			    and coalesce(dk.uppks_kesertaan::text, '-') = coalesce(v_uppks_kesertaan::text, coalesce(dk.uppks_kesertaan::text, '-'))
			    )
			    or (di.nik like '%' || coalesce(v_nik, 'not found') || '%'
			 	and hd.id_provinsi = coalesce(v_id_propinsi, hd.id_provinsi)
			    and hd.id_kabupaten = coalesce(v_id_kabupaten, hd.id_kabupaten)
			    and hd.id_kecamatan = coalesce(v_id_kecamatan, hd.id_kecamatan)
			    and hd.id_kelurahan = coalesce(v_id_kelurahan, hd.id_kelurahan)
			    and hd.id_rw = coalesce(v_id_rw, hd.id_rw)
			    and hd.id_rt = coalesce(v_id_rt, hd.id_rt)
			    )
			) rek
             ------- << source PK >> -------
             full join (select a.kki
				,a.nik
				,a.nama
				,a.hubungan_dengan_kk
				,a.tanggal_lahir
				,to_char(age(now(), a.tanggal_lahir::timestamp with time zone), 'YYYY'::text)::integer usia
				,a.no_telepon
				,a.alamat
				,a.jumlah_anak
				,a.kesertaan_jkn
				,case when to_char(age(now(), a.tgl_lahir_istri::timestamp with time zone), 'YYYY'::text)::integer >= 15 AND to_char(age(now(), a.tgl_lahir_istri::timestamp with time zone), 'YYYY'::text)::integer <= 49 THEN true
				else false end as status_pus
				,a.status_hamil
				,a.metode_kontrasepsi
				,a.jalur_pelayanan
				,a.ingin_anak_segera
				,a.ingin_anak_kemudian
				,a.tidak_ingin_anak_lagi
				,case when to_char(age(now(), a.tgl_lahir_balita::timestamp with time zone), 'YYYY'::text)::integer >= 0 AND to_char(age(now(), a.tgl_lahir_balita::timestamp with time zone), 'YYYY'::text)::integer <= 6 then true
				else false end as keluarga_sasaran_bkb
				,a.kesertaan_bkb
				,case when to_char(age(now(), a.tgl_lahir_remaja::timestamp with time zone), 'YYYY'::text)::integer >= 10 AND to_char(age(now(), a.tgl_lahir_remaja::timestamp with time zone), 'YYYY'::text)::integer <= 24 then true
				else false end as keluarga_sasaran_bkr
				,a.kesertaan_bkr
				,case when to_char(age(now(), a.tgl_lahir_lansia::timestamp with time zone), 'YYYY'::text)::integer >= 60 then true
				else false end as keluarga_sasaran_bkl
				,a.kesertaan_bkl
				,a.id_provinsi
				,a.id_kabupaten
				,a.id_kecamatan
				,a.id_kelurahan
				,a.id_rw
				,a.id_rt
				,a.lama_ber_kb
				,a.uppks_kesertaan
				,a.mutasi
				,a.created_date
				,a.kesertaan_berkb
				,a.status_peserta_kb
				,a.bulan_kapan_mulai
				,a.tahun_kapan_mulai
				,a.bulan_kapan_berhenti
				,a.tahun_kapan_berhenti
				,a.sumber_data
				,a.jumlah_balita
				,a.jumlah_remaja
				,a.jumlah_lansia
             from sigabaru.rekap_pk_tmp_inherit a
             where (v_nik is null
			 	and a.id_provinsi = coalesce(v_id_propinsi, a.id_provinsi)
			    and a.id_kabupaten = coalesce(v_id_kabupaten, a.id_kabupaten)
			    and a.id_kecamatan = coalesce(v_id_kecamatan, a.id_kecamatan)
			    and a.id_kelurahan = coalesce(v_id_kelurahan, a.id_kelurahan)
			    and a.id_rw = coalesce(v_id_rw, a.id_rw)
			    and a.id_rt = coalesce(v_id_rt, a.id_rt)
			    and upper(a.nama) like '%' || upper(coalesce(v_nama, a.nama)) || '%'
				and upper(a.hubungan_dengan_kk) = 'KK'
				and coalesce(a.kesertaan_jkn::text, '-') = coalesce(v_kesertaan_jkn::text, coalesce(a.kesertaan_jkn::text, '-'))
			    and coalesce((case when to_char(age(now(), a.tgl_lahir_istri::timestamp with time zone), 'YYYY'::text)::integer >= 15 AND to_char(age(now(), a.tgl_lahir_istri::timestamp with time zone), 'YYYY'::text)::integer <= 49 THEN true else false end)::text, '-') 
			    = coalesce(v_status_pus::text, coalesce((case when to_char(age(now(), a.tgl_lahir_istri::timestamp with time zone), 'YYYY'::text)::integer >= 15 AND to_char(age(now(), a.tgl_lahir_istri::timestamp with time zone), 'YYYY'::text)::integer <= 49 THEN true else false end)::text, '-'))
			    and coalesce(a.status_hamil::text, '-') = coalesce(v_status_hamil::text, coalesce(a.status_hamil::text, '-'))
			    and coalesce(a.metode_kontrasepsi, '-') = coalesce(v_metode_kontrasepsi, coalesce(a.metode_kontrasepsi, '-'))
			    and coalesce(a.jalur_pelayanan, '-') = coalesce(v_jalur_pelayanan, coalesce(a.jalur_pelayanan, '-'))
			    and coalesce(a.ingin_anak_segera::text, '-') = coalesce(v_ingin_anak_segera::text, coalesce(a.ingin_anak_segera::text, '-'))
			    and coalesce(a.ingin_anak_kemudian::text, '-') = coalesce(v_ingin_anak_kemudian::text, coalesce(a.ingin_anak_kemudian::text, '-'))
			    and coalesce(a.tidak_ingin_anak_lagi::text, '-') = coalesce(v_tidak_ingin_anak_lagi::text, coalesce(a.tidak_ingin_anak_lagi::text, '-'))
			    and coalesce((case when to_char(age(now(), a.tgl_lahir_balita::timestamp with time zone), 'YYYY'::text)::integer >= 0 AND to_char(age(now(), a.tgl_lahir_balita::timestamp with time zone), 'YYYY'::text)::integer <= 6 then true else false end)::text, '-') 
			    = coalesce(v_keluarga_sasaran_bkb::text, coalesce((case when to_char(age(now(), a.tgl_lahir_balita::timestamp with time zone), 'YYYY'::text)::integer >= 0 AND to_char(age(now(), a.tgl_lahir_balita::timestamp with time zone), 'YYYY'::text)::integer <= 6 then true else false end)::text, '-'))
			    and coalesce(a.kesertaan_bkb::text, '-') = coalesce(v_kesertaan_bkb::text, coalesce(a.kesertaan_bkb::text, '-'))
			    and coalesce((case when to_char(age(now(), a.tgl_lahir_remaja::timestamp with time zone), 'YYYY'::text)::integer >= 10 AND to_char(age(now(), a.tgl_lahir_remaja::timestamp with time zone), 'YYYY'::text)::integer <= 24 then true else false end)::text, '-') 
			    = coalesce(v_keluarga_sasaran_bkr::text, coalesce((case when to_char(age(now(), a.tgl_lahir_remaja::timestamp with time zone), 'YYYY'::text)::integer >= 10 AND to_char(age(now(), a.tgl_lahir_remaja::timestamp with time zone), 'YYYY'::text)::integer <= 24 then true else false end)::text, '-'))
			    and coalesce(a.kesertaan_bkr::text, '-') = coalesce(v_kesertaan_bkr::text, coalesce(a.kesertaan_bkr::text, '-'))
			    and coalesce((case when to_char(age(now(), a.tgl_lahir_lansia::timestamp with time zone), 'YYYY'::text)::integer >= 60 then true else false end)::text, '-') 
			    = coalesce(v_keluarga_sasaran_bkl::text, coalesce((case when to_char(age(now(), a.tgl_lahir_lansia::timestamp with time zone), 'YYYY'::text)::integer >= 60 then true else false end)::text, '-'))
			    and coalesce(a.kesertaan_bkl::text, '-') = coalesce(v_kesertaan_bkl::text, coalesce(a.kesertaan_bkl::text, '-'))
			    and coalesce(a.uppks_kesertaan::text, '-') = coalesce(v_uppks_kesertaan::text, coalesce(a.uppks_kesertaan::text, '-'))
			    )
			    or (a.nik like '%' || coalesce(v_nik, 'not found') || '%'
			 	and a.id_provinsi = coalesce(v_id_propinsi, a.id_provinsi)
			    and a.id_kabupaten = coalesce(v_id_kabupaten, a.id_kabupaten)
			    and a.id_kecamatan = coalesce(v_id_kecamatan, a.id_kecamatan)
			    and a.id_kelurahan = coalesce(v_id_kelurahan, a.id_kelurahan)
			    and a.id_rw = coalesce(v_id_rw, a.id_rw)
			    and a.id_rt = coalesce(v_id_rt, a.id_rt)
			    )
			) pk
             ON COALESCE(rek.kki, '-'::character varying)::text = COALESCE(pk.kki, '-'::character varying)::text 
--             AND COALESCE(rek.nik, '-'::character varying)::text = COALESCE(pk.nik, '-'::text) 
--             AND btrim(rek.nama::text) = btrim(pk.nama::text)
             ------- << source poktan + YanKB >> -------
             FULL JOIN ( SELECT *
                   FROM ( SELECT a.*,
                            lead(tahun_rekap) OVER (PARTITION BY a.kki ORDER BY a.tahun_rekap, a.bulan_rekap) AS flag
                           FROM sigabaru.rekap_siga_tmp a
                          WHERE --bulan_rekap::integer <= COALESCE(v_bulan, to_char(now(), 'MM'::text)::integer) 
--                          AND tahun_rekap::integer <= COALESCE(v_tahun, to_char(now(), 'YYYY'::text)::integer)
                          (concat(tahun_rekap::varchar, lpad(bulan_rekap::varchar,2,'0')))::int <= (coalesce(concat(v_tahun::varchar, lpad(v_bulan::varchar,2,'0')), to_char(now(), 'YYYYMM')))::int
                          ) b
                  WHERE b.flag IS null
                  and b.nik like '%' || coalesce(v_nik, 'not found') || '%') bkb 
                  ON COALESCE(COALESCE(rek.kki, pk.kki), '-'::character varying)::text = COALESCE(bkb.kki, '-'::character varying)::text
    where (rek.tgl_mutasi_individu is null or to_char(rek.tgl_mutasi_individu, 'YYYYMM') >= coalesce(concat(v_tahun::varchar, lpad(v_bulan::varchar,2,'0')), to_char(now(), 'YYYYMM')))
	or (rek.tgl_mutasi_keluarga is null or to_char(rek.tgl_mutasi_keluarga, 'YYYYMM') >= coalesce(concat(v_tahun::varchar, lpad(v_bulan::varchar,2,'0')), to_char(now(), 'YYYYMM')))
	order by kki
	offset v_offset
	limit v_limit
	;
end;
$function$
;

-- Permissions

ALTER FUNCTION sigabaru.f_rekap_pk_siga(int4,int4,varchar,varchar,int4,int4,int4,int4,int4,int4,bool,bool,bool,varchar,varchar,bool,bool,bool,bool,bool,bool,bool,bool,bool,bool,int4,int4) OWNER TO developer;
GRANT ALL ON FUNCTION sigabaru.f_rekap_pk_siga(int4,int4,varchar,varchar,int4,int4,int4,int4,int4,int4,bool,bool,bool,varchar,varchar,bool,bool,bool,bool,bool,bool,bool,bool,bool,bool,int4,int4) TO developer;
