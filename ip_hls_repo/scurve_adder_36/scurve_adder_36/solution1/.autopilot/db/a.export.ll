; ModuleID = '/home/alx/xil_proj/zynq_board/master2/ip_hls_repo/scurve_adder_36/scurve_adder_36/solution1/.autopilot/db/a.o.2.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@scurve_adder36_str = internal unnamed_addr constant [15 x i8] c"scurve_adder36\00"
@llvm_global_ctors_1 = appending global [0 x void ()*] zeroinitializer
@llvm_global_ctors_0 = appending global [0 x i32] zeroinitializer
@p_str7 = private unnamed_addr constant [12 x i8] c"hls_label_2\00", align 1
@p_str6 = private unnamed_addr constant [12 x i8] c"hls_label_1\00", align 1
@p_str5 = private unnamed_addr constant [12 x i8] c"hls_label_0\00", align 1
@p_str4 = private unnamed_addr constant [9 x i8] c"CTRL_BUS\00", align 1
@p_str3 = private unnamed_addr constant [10 x i8] c"s_axilite\00", align 1
@p_str2 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@p_str1 = private unnamed_addr constant [5 x i8] c"both\00", align 1
@p_str = private unnamed_addr constant [5 x i8] c"axis\00", align 1

define void @scurve_adder36(i128* %in_stream0_V_data_V, i16* %in_stream0_V_keep_V, i16* %in_stream0_V_strb_V, i8* %in_stream0_V_user_V, i1* %in_stream0_V_last_V, i5* %in_stream0_V_id_V, i6* %in_stream0_V_dest_V, i512* %out_stream_V_data_V, i64* %out_stream_V_keep_V, i64* %out_stream_V_strb_V, i8* %out_stream_V_user_V, i1* %out_stream_V_last_V, i5* %out_stream_V_id_V, i6* %out_stream_V_dest_V, i16 zeroext %N_ADDS, i32 %TEST_MODE, i16 zeroext %K_TLAST) {
  call void (...)* @_ssdm_op_SpecBitsMap(i128* %in_stream0_V_data_V), !map !69
  call void (...)* @_ssdm_op_SpecBitsMap(i16* %in_stream0_V_keep_V), !map !73
  call void (...)* @_ssdm_op_SpecBitsMap(i16* %in_stream0_V_strb_V), !map !77
  call void (...)* @_ssdm_op_SpecBitsMap(i8* %in_stream0_V_user_V), !map !81
  call void (...)* @_ssdm_op_SpecBitsMap(i1* %in_stream0_V_last_V), !map !85
  call void (...)* @_ssdm_op_SpecBitsMap(i5* %in_stream0_V_id_V), !map !89
  call void (...)* @_ssdm_op_SpecBitsMap(i6* %in_stream0_V_dest_V), !map !93
  call void (...)* @_ssdm_op_SpecBitsMap(i512* %out_stream_V_data_V), !map !97
  call void (...)* @_ssdm_op_SpecBitsMap(i64* %out_stream_V_keep_V), !map !101
  call void (...)* @_ssdm_op_SpecBitsMap(i64* %out_stream_V_strb_V), !map !105
  call void (...)* @_ssdm_op_SpecBitsMap(i8* %out_stream_V_user_V), !map !109
  call void (...)* @_ssdm_op_SpecBitsMap(i1* %out_stream_V_last_V), !map !113
  call void (...)* @_ssdm_op_SpecBitsMap(i5* %out_stream_V_id_V), !map !117
  call void (...)* @_ssdm_op_SpecBitsMap(i6* %out_stream_V_dest_V), !map !121
  call void (...)* @_ssdm_op_SpecBitsMap(i16 %N_ADDS), !map !125
  call void (...)* @_ssdm_op_SpecBitsMap(i32 %TEST_MODE), !map !131
  call void (...)* @_ssdm_op_SpecBitsMap(i16 %K_TLAST), !map !135
  call void (...)* @_ssdm_op_SpecTopModule([15 x i8]* @scurve_adder36_str) nounwind
  %K_TLAST_read = call i16 @_ssdm_op_Read.s_axilite.i16(i16 %K_TLAST)
  %TEST_MODE_read = call i32 @_ssdm_op_Read.s_axilite.i32(i32 %TEST_MODE)
  %N_ADDS_read = call i16 @_ssdm_op_Read.s_axilite.i16(i16 %N_ADDS)
  %sum_pix_ch0_0 = alloca [180 x i32], align 16
  %sum_pix_ch0_1 = alloca [180 x i32], align 16
  %sum_pix_ch0_2 = alloca [180 x i32], align 16
  %sum_pix_ch0_3 = alloca [180 x i32], align 16
  %sum_pix_ch0_4 = alloca [180 x i32], align 16
  %sum_pix_ch0_5 = alloca [180 x i32], align 16
  %sum_pix_ch0_6 = alloca [180 x i32], align 16
  %sum_pix_ch0_7 = alloca [180 x i32], align 16
  %sum_pix_ch0_8 = alloca [180 x i32], align 16
  %sum_pix_ch0_9 = alloca [180 x i32], align 16
  %sum_pix_ch0_10 = alloca [180 x i32], align 16
  %sum_pix_ch0_11 = alloca [180 x i32], align 16
  %sum_pix_ch0_12 = alloca [180 x i32], align 16
  %sum_pix_ch0_13 = alloca [180 x i32], align 16
  %sum_pix_ch0_14 = alloca [180 x i32], align 16
  %sum_pix_ch0_15 = alloca [180 x i32], align 16
  call void (...)* @_ssdm_op_SpecInterface(i128* %in_stream0_V_data_V, i16* %in_stream0_V_keep_V, i16* %in_stream0_V_strb_V, i8* %in_stream0_V_user_V, i1* %in_stream0_V_last_V, i5* %in_stream0_V_id_V, i6* %in_stream0_V_dest_V, [5 x i8]* @p_str, i32 1, i32 1, [5 x i8]* @p_str1, i32 0, i32 0, [1 x i8]* @p_str2, [1 x i8]* @p_str2, [1 x i8]* @p_str2, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str2, [1 x i8]* @p_str2) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i512* %out_stream_V_data_V, i64* %out_stream_V_keep_V, i64* %out_stream_V_strb_V, i8* %out_stream_V_user_V, i1* %out_stream_V_last_V, i5* %out_stream_V_id_V, i6* %out_stream_V_dest_V, [5 x i8]* @p_str, i32 1, i32 1, [5 x i8]* @p_str1, i32 0, i32 0, [1 x i8]* @p_str2, [1 x i8]* @p_str2, [1 x i8]* @p_str2, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str2, [1 x i8]* @p_str2) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i16 %N_ADDS, [10 x i8]* @p_str3, i32 0, i32 0, [1 x i8]* @p_str2, i32 0, i32 0, [9 x i8]* @p_str4, [1 x i8]* @p_str2, [1 x i8]* @p_str2, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str2, [1 x i8]* @p_str2) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i32 %TEST_MODE, [10 x i8]* @p_str3, i32 0, i32 0, [1 x i8]* @p_str2, i32 0, i32 0, [9 x i8]* @p_str4, [1 x i8]* @p_str2, [1 x i8]* @p_str2, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str2, [1 x i8]* @p_str2) nounwind
  %tmp_1_cast = zext i16 %K_TLAST_read to i17
  call void (...)* @_ssdm_op_SpecInterface(i16 %K_TLAST, [10 x i8]* @p_str3, i32 0, i32 0, [1 x i8]* @p_str2, i32 0, i32 0, [9 x i8]* @p_str4, [1 x i8]* @p_str2, [1 x i8]* @p_str2, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str2, [1 x i8]* @p_str2) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i32 0, [10 x i8]* @p_str3, i32 0, i32 0, [1 x i8]* @p_str2, i32 0, i32 0, [9 x i8]* @p_str4, [1 x i8]* @p_str2, [1 x i8]* @p_str2, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str2, [1 x i8]* @p_str2) nounwind
  %tmp_2 = add i17 %tmp_1_cast, -1
  %tmp_3 = icmp eq i32 %TEST_MODE_read, 0
  %cast = zext i16 %N_ADDS_read to i24
  %bound = mul i24 %cast, 180
  br label %.loopexit

.loopexit.loopexit:                               ; preds = %.preheader164
  br label %.loopexit

.loopexit:                                        ; preds = %.loopexit.loopexit, %0
  %k_tlast_cnt = phi i16 [ 0, %0 ], [ %k_tlast_cnt_1, %.loopexit.loopexit ]
  %exitcond1 = icmp eq i16 %k_tlast_cnt, %K_TLAST_read
  %k_tlast_cnt_1 = add i16 %k_tlast_cnt, 1
  br i1 %exitcond1, label %2, label %.preheader167.preheader

.preheader167.preheader:                          ; preds = %.loopexit
  br label %.preheader167

.preheader167:                                    ; preds = %.preheader167.preheader, %1
  %i = phi i8 [ %i_3, %1 ], [ 0, %.preheader167.preheader ]
  %exitcond2 = icmp eq i8 %i, -76
  %empty = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 180, i64 180, i64 180)
  %i_3 = add i8 %i, 1
  br i1 %exitcond2, label %.preheader165.preheader, label %1

.preheader165.preheader:                          ; preds = %.preheader167
  br label %.preheader165

; <label>:1                                       ; preds = %.preheader167
  %tmp_8 = call i32 (...)* @_ssdm_op_SpecRegionBegin([12 x i8]* @p_str5)
  call void (...)* @_ssdm_op_SpecPipeline(i32 -1, i32 1, i32 1, i32 0, [1 x i8]* @p_str2) nounwind
  %tmp_4 = zext i8 %i to i64
  %sum_pix_ch0_0_addr = getelementptr [180 x i32]* %sum_pix_ch0_0, i64 0, i64 %tmp_4
  store i32 0, i32* %sum_pix_ch0_0_addr, align 4
  %sum_pix_ch0_1_addr = getelementptr [180 x i32]* %sum_pix_ch0_1, i64 0, i64 %tmp_4
  store i32 0, i32* %sum_pix_ch0_1_addr, align 4
  %sum_pix_ch0_2_addr = getelementptr [180 x i32]* %sum_pix_ch0_2, i64 0, i64 %tmp_4
  store i32 0, i32* %sum_pix_ch0_2_addr, align 4
  %sum_pix_ch0_3_addr = getelementptr [180 x i32]* %sum_pix_ch0_3, i64 0, i64 %tmp_4
  store i32 0, i32* %sum_pix_ch0_3_addr, align 4
  %sum_pix_ch0_4_addr = getelementptr [180 x i32]* %sum_pix_ch0_4, i64 0, i64 %tmp_4
  store i32 0, i32* %sum_pix_ch0_4_addr, align 4
  %sum_pix_ch0_5_addr = getelementptr [180 x i32]* %sum_pix_ch0_5, i64 0, i64 %tmp_4
  store i32 0, i32* %sum_pix_ch0_5_addr, align 4
  %sum_pix_ch0_6_addr = getelementptr [180 x i32]* %sum_pix_ch0_6, i64 0, i64 %tmp_4
  store i32 0, i32* %sum_pix_ch0_6_addr, align 4
  %sum_pix_ch0_7_addr = getelementptr [180 x i32]* %sum_pix_ch0_7, i64 0, i64 %tmp_4
  store i32 0, i32* %sum_pix_ch0_7_addr, align 4
  %sum_pix_ch0_8_addr = getelementptr [180 x i32]* %sum_pix_ch0_8, i64 0, i64 %tmp_4
  store i32 0, i32* %sum_pix_ch0_8_addr, align 4
  %sum_pix_ch0_9_addr = getelementptr [180 x i32]* %sum_pix_ch0_9, i64 0, i64 %tmp_4
  store i32 0, i32* %sum_pix_ch0_9_addr, align 4
  %sum_pix_ch0_10_addr = getelementptr [180 x i32]* %sum_pix_ch0_10, i64 0, i64 %tmp_4
  store i32 0, i32* %sum_pix_ch0_10_addr, align 4
  %sum_pix_ch0_11_addr = getelementptr [180 x i32]* %sum_pix_ch0_11, i64 0, i64 %tmp_4
  store i32 0, i32* %sum_pix_ch0_11_addr, align 4
  %sum_pix_ch0_12_addr = getelementptr [180 x i32]* %sum_pix_ch0_12, i64 0, i64 %tmp_4
  store i32 0, i32* %sum_pix_ch0_12_addr, align 4
  %sum_pix_ch0_13_addr = getelementptr [180 x i32]* %sum_pix_ch0_13, i64 0, i64 %tmp_4
  store i32 0, i32* %sum_pix_ch0_13_addr, align 4
  %sum_pix_ch0_14_addr = getelementptr [180 x i32]* %sum_pix_ch0_14, i64 0, i64 %tmp_4
  store i32 0, i32* %sum_pix_ch0_14_addr, align 4
  %sum_pix_ch0_15_addr = getelementptr [180 x i32]* %sum_pix_ch0_15, i64 0, i64 %tmp_4
  store i32 0, i32* %sum_pix_ch0_15_addr, align 4
  %empty_5 = call i32 (...)* @_ssdm_op_SpecRegionEnd([12 x i8]* @p_str5, i32 %tmp_8)
  br label %.preheader167

.preheader164.preheader:                          ; preds = %.preheader165
  %tmp_5_cast = zext i16 %k_tlast_cnt to i17
  %tmp_6 = icmp eq i17 %tmp_5_cast, %tmp_2
  br label %.preheader164

.preheader165:                                    ; preds = %.preheader165.preheader, %.preheader166
  %indvar_flatten = phi i24 [ %indvar_flatten_next, %.preheader166 ], [ 0, %.preheader165.preheader ]
  %i_1 = phi i8 [ %i_4, %.preheader166 ], [ 0, %.preheader165.preheader ]
  %exitcond_flatten = icmp eq i24 %indvar_flatten, %bound
  %indvar_flatten_next = add i24 %indvar_flatten, 1
  br i1 %exitcond_flatten, label %.preheader164.preheader, label %.preheader166

.preheader166:                                    ; preds = %.preheader165
  %exitcond = icmp eq i8 %i_1, -76
  %i_1_mid2 = select i1 %exitcond, i8 0, i8 %i_1
  %tmp_10 = call i32 (...)* @_ssdm_op_SpecRegionBegin([12 x i8]* @p_str6)
  call void (...)* @_ssdm_op_SpecPipeline(i32 -1, i32 1, i32 1, i32 0, [1 x i8]* @p_str2) nounwind
  %tmp_7 = zext i8 %i_1_mid2 to i64
  %empty_6 = call { i128, i16, i16, i8, i1, i5, i6 } @_ssdm_op_Read.axis.volatile.i128P.i16P.i16P.i8P.i1P.i5P.i6P(i128* %in_stream0_V_data_V, i16* %in_stream0_V_keep_V, i16* %in_stream0_V_strb_V, i8* %in_stream0_V_user_V, i1* %in_stream0_V_last_V, i5* %in_stream0_V_id_V, i6* %in_stream0_V_dest_V)
  %tmp_data_V = extractvalue { i128, i16, i16, i8, i1, i5, i6 } %empty_6, 0
  %tmp_13 = trunc i128 %tmp_data_V to i8
  %tmp_11 = zext i8 %tmp_13 to i32
  %sum_pix_ch0_0_addr_1 = getelementptr [180 x i32]* %sum_pix_ch0_0, i64 0, i64 %tmp_7
  %sum_pix_ch0_0_load = load i32* %sum_pix_ch0_0_addr_1, align 4
  %tmp_12 = add i32 %sum_pix_ch0_0_load, %tmp_11
  store i32 %tmp_12, i32* %sum_pix_ch0_0_addr_1, align 4
  %phitmp_1 = call i8 @_ssdm_op_PartSelect.i8.i128.i32.i32(i128 %tmp_data_V, i32 8, i32 15)
  %tmp_32_1 = zext i8 %phitmp_1 to i32
  %sum_pix_ch0_1_addr_1 = getelementptr [180 x i32]* %sum_pix_ch0_1, i64 0, i64 %tmp_7
  %sum_pix_ch0_1_load = load i32* %sum_pix_ch0_1_addr_1, align 4
  %tmp_33_1 = add i32 %sum_pix_ch0_1_load, %tmp_32_1
  store i32 %tmp_33_1, i32* %sum_pix_ch0_1_addr_1, align 4
  %phitmp_2 = call i8 @_ssdm_op_PartSelect.i8.i128.i32.i32(i128 %tmp_data_V, i32 16, i32 23)
  %tmp_32_2 = zext i8 %phitmp_2 to i32
  %sum_pix_ch0_2_addr_1 = getelementptr [180 x i32]* %sum_pix_ch0_2, i64 0, i64 %tmp_7
  %sum_pix_ch0_2_load = load i32* %sum_pix_ch0_2_addr_1, align 4
  %tmp_33_2 = add i32 %sum_pix_ch0_2_load, %tmp_32_2
  store i32 %tmp_33_2, i32* %sum_pix_ch0_2_addr_1, align 4
  %phitmp_3 = call i8 @_ssdm_op_PartSelect.i8.i128.i32.i32(i128 %tmp_data_V, i32 24, i32 31)
  %tmp_32_3 = zext i8 %phitmp_3 to i32
  %sum_pix_ch0_3_addr_1 = getelementptr [180 x i32]* %sum_pix_ch0_3, i64 0, i64 %tmp_7
  %sum_pix_ch0_3_load = load i32* %sum_pix_ch0_3_addr_1, align 4
  %tmp_33_3 = add i32 %sum_pix_ch0_3_load, %tmp_32_3
  store i32 %tmp_33_3, i32* %sum_pix_ch0_3_addr_1, align 4
  %phitmp_4 = call i8 @_ssdm_op_PartSelect.i8.i128.i32.i32(i128 %tmp_data_V, i32 32, i32 39)
  %tmp_32_4 = zext i8 %phitmp_4 to i32
  %sum_pix_ch0_4_addr_1 = getelementptr [180 x i32]* %sum_pix_ch0_4, i64 0, i64 %tmp_7
  %sum_pix_ch0_4_load = load i32* %sum_pix_ch0_4_addr_1, align 4
  %tmp_33_4 = add i32 %sum_pix_ch0_4_load, %tmp_32_4
  store i32 %tmp_33_4, i32* %sum_pix_ch0_4_addr_1, align 4
  %phitmp_5 = call i8 @_ssdm_op_PartSelect.i8.i128.i32.i32(i128 %tmp_data_V, i32 40, i32 47)
  %tmp_32_5 = zext i8 %phitmp_5 to i32
  %sum_pix_ch0_5_addr_1 = getelementptr [180 x i32]* %sum_pix_ch0_5, i64 0, i64 %tmp_7
  %sum_pix_ch0_5_load = load i32* %sum_pix_ch0_5_addr_1, align 4
  %tmp_33_5 = add i32 %sum_pix_ch0_5_load, %tmp_32_5
  store i32 %tmp_33_5, i32* %sum_pix_ch0_5_addr_1, align 4
  %phitmp_6 = call i8 @_ssdm_op_PartSelect.i8.i128.i32.i32(i128 %tmp_data_V, i32 48, i32 55)
  %tmp_32_6 = zext i8 %phitmp_6 to i32
  %sum_pix_ch0_6_addr_1 = getelementptr [180 x i32]* %sum_pix_ch0_6, i64 0, i64 %tmp_7
  %sum_pix_ch0_6_load = load i32* %sum_pix_ch0_6_addr_1, align 4
  %tmp_33_6 = add i32 %sum_pix_ch0_6_load, %tmp_32_6
  store i32 %tmp_33_6, i32* %sum_pix_ch0_6_addr_1, align 4
  %phitmp_7 = call i8 @_ssdm_op_PartSelect.i8.i128.i32.i32(i128 %tmp_data_V, i32 56, i32 63)
  %tmp_32_7 = zext i8 %phitmp_7 to i32
  %sum_pix_ch0_7_addr_1 = getelementptr [180 x i32]* %sum_pix_ch0_7, i64 0, i64 %tmp_7
  %sum_pix_ch0_7_load = load i32* %sum_pix_ch0_7_addr_1, align 4
  %tmp_33_7 = add i32 %sum_pix_ch0_7_load, %tmp_32_7
  store i32 %tmp_33_7, i32* %sum_pix_ch0_7_addr_1, align 4
  %phitmp_8 = call i8 @_ssdm_op_PartSelect.i8.i128.i32.i32(i128 %tmp_data_V, i32 64, i32 71)
  %tmp_32_8 = zext i8 %phitmp_8 to i32
  %sum_pix_ch0_8_addr_1 = getelementptr [180 x i32]* %sum_pix_ch0_8, i64 0, i64 %tmp_7
  %sum_pix_ch0_8_load = load i32* %sum_pix_ch0_8_addr_1, align 4
  %tmp_33_8 = add i32 %sum_pix_ch0_8_load, %tmp_32_8
  store i32 %tmp_33_8, i32* %sum_pix_ch0_8_addr_1, align 4
  %phitmp_9 = call i8 @_ssdm_op_PartSelect.i8.i128.i32.i32(i128 %tmp_data_V, i32 72, i32 79)
  %tmp_32_9 = zext i8 %phitmp_9 to i32
  %sum_pix_ch0_9_addr_1 = getelementptr [180 x i32]* %sum_pix_ch0_9, i64 0, i64 %tmp_7
  %sum_pix_ch0_9_load = load i32* %sum_pix_ch0_9_addr_1, align 4
  %tmp_33_9 = add i32 %sum_pix_ch0_9_load, %tmp_32_9
  store i32 %tmp_33_9, i32* %sum_pix_ch0_9_addr_1, align 4
  %phitmp_s = call i8 @_ssdm_op_PartSelect.i8.i128.i32.i32(i128 %tmp_data_V, i32 80, i32 87)
  %tmp_32_s = zext i8 %phitmp_s to i32
  %sum_pix_ch0_10_addr_1 = getelementptr [180 x i32]* %sum_pix_ch0_10, i64 0, i64 %tmp_7
  %sum_pix_ch0_10_load = load i32* %sum_pix_ch0_10_addr_1, align 4
  %tmp_33_s = add i32 %sum_pix_ch0_10_load, %tmp_32_s
  store i32 %tmp_33_s, i32* %sum_pix_ch0_10_addr_1, align 4
  %phitmp_10 = call i8 @_ssdm_op_PartSelect.i8.i128.i32.i32(i128 %tmp_data_V, i32 88, i32 95)
  %tmp_32_10 = zext i8 %phitmp_10 to i32
  %sum_pix_ch0_11_addr_1 = getelementptr [180 x i32]* %sum_pix_ch0_11, i64 0, i64 %tmp_7
  %sum_pix_ch0_11_load = load i32* %sum_pix_ch0_11_addr_1, align 4
  %tmp_33_10 = add i32 %sum_pix_ch0_11_load, %tmp_32_10
  store i32 %tmp_33_10, i32* %sum_pix_ch0_11_addr_1, align 4
  %phitmp_11 = call i8 @_ssdm_op_PartSelect.i8.i128.i32.i32(i128 %tmp_data_V, i32 96, i32 103)
  %tmp_32_11 = zext i8 %phitmp_11 to i32
  %sum_pix_ch0_12_addr_1 = getelementptr [180 x i32]* %sum_pix_ch0_12, i64 0, i64 %tmp_7
  %sum_pix_ch0_12_load = load i32* %sum_pix_ch0_12_addr_1, align 4
  %tmp_33_11 = add i32 %sum_pix_ch0_12_load, %tmp_32_11
  store i32 %tmp_33_11, i32* %sum_pix_ch0_12_addr_1, align 4
  %phitmp_12 = call i8 @_ssdm_op_PartSelect.i8.i128.i32.i32(i128 %tmp_data_V, i32 104, i32 111)
  %tmp_32_12 = zext i8 %phitmp_12 to i32
  %sum_pix_ch0_13_addr_1 = getelementptr [180 x i32]* %sum_pix_ch0_13, i64 0, i64 %tmp_7
  %sum_pix_ch0_13_load = load i32* %sum_pix_ch0_13_addr_1, align 4
  %tmp_33_12 = add i32 %sum_pix_ch0_13_load, %tmp_32_12
  store i32 %tmp_33_12, i32* %sum_pix_ch0_13_addr_1, align 4
  %phitmp_13 = call i8 @_ssdm_op_PartSelect.i8.i128.i32.i32(i128 %tmp_data_V, i32 112, i32 119)
  %tmp_32_13 = zext i8 %phitmp_13 to i32
  %sum_pix_ch0_14_addr_1 = getelementptr [180 x i32]* %sum_pix_ch0_14, i64 0, i64 %tmp_7
  %sum_pix_ch0_14_load = load i32* %sum_pix_ch0_14_addr_1, align 4
  %tmp_33_13 = add i32 %sum_pix_ch0_14_load, %tmp_32_13
  store i32 %tmp_33_13, i32* %sum_pix_ch0_14_addr_1, align 4
  %phitmp_14 = call i8 @_ssdm_op_PartSelect.i8.i128.i32.i32(i128 %tmp_data_V, i32 120, i32 127)
  %tmp_32_14 = zext i8 %phitmp_14 to i32
  %sum_pix_ch0_15_addr_1 = getelementptr [180 x i32]* %sum_pix_ch0_15, i64 0, i64 %tmp_7
  %sum_pix_ch0_15_load = load i32* %sum_pix_ch0_15_addr_1, align 4
  %tmp_33_14 = add i32 %sum_pix_ch0_15_load, %tmp_32_14
  store i32 %tmp_33_14, i32* %sum_pix_ch0_15_addr_1, align 4
  %empty_7 = call i32 (...)* @_ssdm_op_SpecRegionEnd([12 x i8]* @p_str6, i32 %tmp_10)
  %i_4 = add i8 1, %i_1_mid2
  br label %.preheader165

.preheader164:                                    ; preds = %_ifconv, %.preheader164.preheader
  %i_2 = phi i8 [ %i_5, %_ifconv ], [ 0, %.preheader164.preheader ]
  %exitcond5 = icmp eq i8 %i_2, -76
  %empty_8 = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 180, i64 180, i64 180)
  %i_5 = add i8 %i_2, 1
  br i1 %exitcond5, label %.loopexit.loopexit, label %_ifconv

_ifconv:                                          ; preds = %.preheader164
  %tmp_1 = call i32 (...)* @_ssdm_op_SpecRegionBegin([12 x i8]* @p_str7)
  call void (...)* @_ssdm_op_SpecPipeline(i32 -1, i32 1, i32 1, i32 0, [1 x i8]* @p_str2) nounwind
  %tmp_s = icmp eq i8 %i_2, -77
  %tmp_last_V = and i1 %tmp_s, %tmp_6
  %tmp_9 = zext i8 %i_2 to i64
  %sum_pix_ch0_0_addr_2 = getelementptr [180 x i32]* %sum_pix_ch0_0, i64 0, i64 %tmp_9
  %sum_pix_ch0_0_load_1 = load i32* %sum_pix_ch0_0_addr_2, align 4
  %sum_pix_ch0_1_addr_2 = getelementptr [180 x i32]* %sum_pix_ch0_1, i64 0, i64 %tmp_9
  %sum_pix_ch0_1_load_1 = load i32* %sum_pix_ch0_1_addr_2, align 4
  %sum_pix_ch0_2_addr_2 = getelementptr [180 x i32]* %sum_pix_ch0_2, i64 0, i64 %tmp_9
  %sum_pix_ch0_2_load_1 = load i32* %sum_pix_ch0_2_addr_2, align 4
  %sum_pix_ch0_3_addr_2 = getelementptr [180 x i32]* %sum_pix_ch0_3, i64 0, i64 %tmp_9
  %sum_pix_ch0_3_load_1 = load i32* %sum_pix_ch0_3_addr_2, align 4
  %sum_pix_ch0_4_addr_2 = getelementptr [180 x i32]* %sum_pix_ch0_4, i64 0, i64 %tmp_9
  %sum_pix_ch0_4_load_1 = load i32* %sum_pix_ch0_4_addr_2, align 4
  %sum_pix_ch0_5_addr_2 = getelementptr [180 x i32]* %sum_pix_ch0_5, i64 0, i64 %tmp_9
  %sum_pix_ch0_5_load_1 = load i32* %sum_pix_ch0_5_addr_2, align 4
  %sum_pix_ch0_6_addr_2 = getelementptr [180 x i32]* %sum_pix_ch0_6, i64 0, i64 %tmp_9
  %sum_pix_ch0_6_load_1 = load i32* %sum_pix_ch0_6_addr_2, align 4
  %sum_pix_ch0_7_addr_2 = getelementptr [180 x i32]* %sum_pix_ch0_7, i64 0, i64 %tmp_9
  %sum_pix_ch0_7_load_1 = load i32* %sum_pix_ch0_7_addr_2, align 4
  %sum_pix_ch0_8_addr_2 = getelementptr [180 x i32]* %sum_pix_ch0_8, i64 0, i64 %tmp_9
  %sum_pix_ch0_8_load_1 = load i32* %sum_pix_ch0_8_addr_2, align 4
  %sum_pix_ch0_9_addr_2 = getelementptr [180 x i32]* %sum_pix_ch0_9, i64 0, i64 %tmp_9
  %sum_pix_ch0_9_load_1 = load i32* %sum_pix_ch0_9_addr_2, align 4
  %sum_pix_ch0_10_addr_2 = getelementptr [180 x i32]* %sum_pix_ch0_10, i64 0, i64 %tmp_9
  %sum_pix_ch0_10_load_1 = load i32* %sum_pix_ch0_10_addr_2, align 4
  %sum_pix_ch0_11_addr_2 = getelementptr [180 x i32]* %sum_pix_ch0_11, i64 0, i64 %tmp_9
  %sum_pix_ch0_11_load_1 = load i32* %sum_pix_ch0_11_addr_2, align 4
  %sum_pix_ch0_12_addr_2 = getelementptr [180 x i32]* %sum_pix_ch0_12, i64 0, i64 %tmp_9
  %sum_pix_ch0_12_load_1 = load i32* %sum_pix_ch0_12_addr_2, align 4
  %sum_pix_ch0_13_addr_2 = getelementptr [180 x i32]* %sum_pix_ch0_13, i64 0, i64 %tmp_9
  %sum_pix_ch0_13_load_1 = load i32* %sum_pix_ch0_13_addr_2, align 4
  %sum_pix_ch0_14_addr_2 = getelementptr [180 x i32]* %sum_pix_ch0_14, i64 0, i64 %tmp_9
  %sum_pix_ch0_14_load_1 = load i32* %sum_pix_ch0_14_addr_2, align 4
  %sum_pix_ch0_15_addr_2 = getelementptr [180 x i32]* %sum_pix_ch0_15, i64 0, i64 %tmp_9
  %sum_pix_ch0_15_load_1 = load i32* %sum_pix_ch0_15_addr_2, align 4
  %sum_pix_tot_data_V_s = call i512 @_ssdm_op_BitConcatenate.i512.i32.i32.i32.i32.i32.i32.i32.i32.i32.i32.i32.i32.i32.i32.i32.i32(i32 %sum_pix_ch0_15_load_1, i32 %sum_pix_ch0_14_load_1, i32 %sum_pix_ch0_13_load_1, i32 %sum_pix_ch0_12_load_1, i32 %sum_pix_ch0_11_load_1, i32 %sum_pix_ch0_10_load_1, i32 %sum_pix_ch0_9_load_1, i32 %sum_pix_ch0_8_load_1, i32 %sum_pix_ch0_7_load_1, i32 %sum_pix_ch0_6_load_1, i32 %sum_pix_ch0_5_load_1, i32 %sum_pix_ch0_4_load_1, i32 %sum_pix_ch0_3_load_1, i32 %sum_pix_ch0_2_load_1, i32 %sum_pix_ch0_1_load_1, i32 %sum_pix_ch0_0_load_1)
  %tmp_5 = call i12 @_ssdm_op_BitConcatenate.i12.i8.i4(i8 %i_2, i4 0)
  %tmp_10_cast = zext i12 %tmp_5 to i32
  %val_assign_1_s = or i12 %tmp_5, 1
  %val_assign_1_cast = zext i12 %val_assign_1_s to i32
  %val_assign_1_1 = or i12 %tmp_5, 2
  %val_assign_1_1_cast = zext i12 %val_assign_1_1 to i32
  %val_assign_1_2 = or i12 %tmp_5, 3
  %val_assign_1_2_cast = zext i12 %val_assign_1_2 to i32
  %val_assign_1_3 = or i12 %tmp_5, 4
  %val_assign_1_3_cast = zext i12 %val_assign_1_3 to i32
  %val_assign_1_4 = or i12 %tmp_5, 5
  %val_assign_1_4_cast = zext i12 %val_assign_1_4 to i32
  %val_assign_1_5 = or i12 %tmp_5, 6
  %val_assign_1_5_cast = zext i12 %val_assign_1_5 to i32
  %val_assign_1_6 = or i12 %tmp_5, 7
  %val_assign_1_6_cast = zext i12 %val_assign_1_6 to i32
  %val_assign_1_7 = or i12 %tmp_5, 8
  %val_assign_1_7_cast = zext i12 %val_assign_1_7 to i32
  %val_assign_1_8 = or i12 %tmp_5, 9
  %val_assign_1_8_cast = zext i12 %val_assign_1_8 to i32
  %val_assign_1_9 = or i12 %tmp_5, 10
  %val_assign_1_9_cast = zext i12 %val_assign_1_9 to i32
  %val_assign_1_10 = or i12 %tmp_5, 11
  %val_assign_1_10_cast = zext i12 %val_assign_1_10 to i32
  %val_assign_1_11 = or i12 %tmp_5, 12
  %val_assign_1_11_cast = zext i12 %val_assign_1_11 to i32
  %val_assign_1_12 = or i12 %tmp_5, 13
  %val_assign_1_12_cast = zext i12 %val_assign_1_12 to i32
  %val_assign_1_13 = or i12 %tmp_5, 14
  %val_assign_1_13_cast = zext i12 %val_assign_1_13 to i32
  %val_assign_1_14 = or i12 %tmp_5, 15
  %tmp = call i492 @_ssdm_op_BitConcatenate.i492.i12.i32.i32.i32.i32.i32.i32.i32.i32.i32.i32.i32.i32.i32.i32.i32(i12 %val_assign_1_14, i32 %val_assign_1_13_cast, i32 %val_assign_1_12_cast, i32 %val_assign_1_11_cast, i32 %val_assign_1_10_cast, i32 %val_assign_1_9_cast, i32 %val_assign_1_8_cast, i32 %val_assign_1_7_cast, i32 %val_assign_1_6_cast, i32 %val_assign_1_5_cast, i32 %val_assign_1_4_cast, i32 %val_assign_1_3_cast, i32 %val_assign_1_2_cast, i32 %val_assign_1_1_cast, i32 %val_assign_1_cast, i32 %tmp_10_cast)
  %sum_pix_tot_data_V_1 = zext i492 %tmp to i512
  %tmp_data_V_1 = select i1 %tmp_3, i512 %sum_pix_tot_data_V_s, i512 %sum_pix_tot_data_V_1
  call void @_ssdm_op_Write.axis.volatile.i512P.i64P.i64P.i8P.i1P.i5P.i6P(i512* %out_stream_V_data_V, i64* %out_stream_V_keep_V, i64* %out_stream_V_strb_V, i8* %out_stream_V_user_V, i1* %out_stream_V_last_V, i5* %out_stream_V_id_V, i6* %out_stream_V_dest_V, i512 %tmp_data_V_1, i64 -1, i64 -1, i8 0, i1 %tmp_last_V, i5 0, i6 0)
  %empty_9 = call i32 (...)* @_ssdm_op_SpecRegionEnd([12 x i8]* @p_str7, i32 %tmp_1)
  br label %.preheader164

; <label>:2                                       ; preds = %.loopexit
  ret void
}

declare i128 @llvm.part.select.i128(i128, i32, i32) nounwind readnone

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

define weak void @_ssdm_op_Write.axis.volatile.i512P.i64P.i64P.i8P.i1P.i5P.i6P(i512*, i64*, i64*, i8*, i1*, i5*, i6*, i512, i64, i64, i8, i1, i5, i6) {
entry:
  store i512 %7, i512* %0
  store i64 %8, i64* %1
  store i64 %9, i64* %2
  store i8 %10, i8* %3
  store i1 %11, i1* %4
  store i5 %12, i5* %5
  store i6 %13, i6* %6
  ret void
}

define weak void @_ssdm_op_SpecTopModule(...) {
entry:
  ret void
}

define weak i32 @_ssdm_op_SpecRegionEnd(...) {
entry:
  ret i32 0
}

define weak i32 @_ssdm_op_SpecRegionBegin(...) {
entry:
  ret i32 0
}

define weak void @_ssdm_op_SpecPipeline(...) nounwind {
entry:
  ret void
}

define weak i32 @_ssdm_op_SpecLoopTripCount(...) {
entry:
  ret i32 0
}

define weak void @_ssdm_op_SpecInterface(...) nounwind {
entry:
  ret void
}

define weak void @_ssdm_op_SpecBitsMap(...) {
entry:
  ret void
}

define weak i32 @_ssdm_op_Read.s_axilite.i32(i32) {
entry:
  ret i32 %0
}

define weak i16 @_ssdm_op_Read.s_axilite.i16(i16) {
entry:
  ret i16 %0
}

define weak { i128, i16, i16, i8, i1, i5, i6 } @_ssdm_op_Read.axis.volatile.i128P.i16P.i16P.i8P.i1P.i5P.i6P(i128*, i16*, i16*, i8*, i1*, i5*, i6*) {
entry:
  %empty = load i128* %0
  %empty_10 = load i16* %1
  %empty_11 = load i16* %2
  %empty_12 = load i8* %3
  %empty_13 = load i1* %4
  %empty_14 = load i5* %5
  %empty_15 = load i6* %6
  %mrv_0 = insertvalue { i128, i16, i16, i8, i1, i5, i6 } undef, i128 %empty, 0
  %mrv1 = insertvalue { i128, i16, i16, i8, i1, i5, i6 } %mrv_0, i16 %empty_10, 1
  %mrv2 = insertvalue { i128, i16, i16, i8, i1, i5, i6 } %mrv1, i16 %empty_11, 2
  %mrv3 = insertvalue { i128, i16, i16, i8, i1, i5, i6 } %mrv2, i8 %empty_12, 3
  %mrv4 = insertvalue { i128, i16, i16, i8, i1, i5, i6 } %mrv3, i1 %empty_13, 4
  %mrv5 = insertvalue { i128, i16, i16, i8, i1, i5, i6 } %mrv4, i5 %empty_14, 5
  %mrv6 = insertvalue { i128, i16, i16, i8, i1, i5, i6 } %mrv5, i6 %empty_15, 6
  ret { i128, i16, i16, i8, i1, i5, i6 } %mrv6
}

define weak i8 @_ssdm_op_PartSelect.i8.i128.i32.i32(i128, i32, i32) nounwind readnone {
entry:
  %empty = call i128 @llvm.part.select.i128(i128 %0, i32 %1, i32 %2)
  %empty_16 = trunc i128 %empty to i8
  ret i8 %empty_16
}

define weak i512 @_ssdm_op_BitConcatenate.i512.i32.i32.i32.i32.i32.i32.i32.i32.i32.i32.i32.i32.i32.i32.i32.i32(i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32) nounwind readnone {
entry:
  %empty = zext i32 %14 to i64
  %empty_17 = zext i32 %15 to i64
  %empty_18 = shl i64 %empty, 32
  %empty_19 = or i64 %empty_18, %empty_17
  %empty_20 = zext i32 %13 to i96
  %empty_21 = zext i64 %empty_19 to i96
  %empty_22 = shl i96 %empty_20, 64
  %empty_23 = or i96 %empty_22, %empty_21
  %empty_24 = zext i32 %12 to i128
  %empty_25 = zext i96 %empty_23 to i128
  %empty_26 = shl i128 %empty_24, 96
  %empty_27 = or i128 %empty_26, %empty_25
  %empty_28 = zext i32 %11 to i160
  %empty_29 = zext i128 %empty_27 to i160
  %empty_30 = shl i160 %empty_28, 128
  %empty_31 = or i160 %empty_30, %empty_29
  %empty_32 = zext i32 %10 to i192
  %empty_33 = zext i160 %empty_31 to i192
  %empty_34 = shl i192 %empty_32, 160
  %empty_35 = or i192 %empty_34, %empty_33
  %empty_36 = zext i32 %9 to i224
  %empty_37 = zext i192 %empty_35 to i224
  %empty_38 = shl i224 %empty_36, 192
  %empty_39 = or i224 %empty_38, %empty_37
  %empty_40 = zext i32 %8 to i256
  %empty_41 = zext i224 %empty_39 to i256
  %empty_42 = shl i256 %empty_40, 224
  %empty_43 = or i256 %empty_42, %empty_41
  %empty_44 = zext i32 %7 to i288
  %empty_45 = zext i256 %empty_43 to i288
  %empty_46 = shl i288 %empty_44, 256
  %empty_47 = or i288 %empty_46, %empty_45
  %empty_48 = zext i32 %6 to i320
  %empty_49 = zext i288 %empty_47 to i320
  %empty_50 = shl i320 %empty_48, 288
  %empty_51 = or i320 %empty_50, %empty_49
  %empty_52 = zext i32 %5 to i352
  %empty_53 = zext i320 %empty_51 to i352
  %empty_54 = shl i352 %empty_52, 320
  %empty_55 = or i352 %empty_54, %empty_53
  %empty_56 = zext i32 %4 to i384
  %empty_57 = zext i352 %empty_55 to i384
  %empty_58 = shl i384 %empty_56, 352
  %empty_59 = or i384 %empty_58, %empty_57
  %empty_60 = zext i32 %3 to i416
  %empty_61 = zext i384 %empty_59 to i416
  %empty_62 = shl i416 %empty_60, 384
  %empty_63 = or i416 %empty_62, %empty_61
  %empty_64 = zext i32 %2 to i448
  %empty_65 = zext i416 %empty_63 to i448
  %empty_66 = shl i448 %empty_64, 416
  %empty_67 = or i448 %empty_66, %empty_65
  %empty_68 = zext i32 %1 to i480
  %empty_69 = zext i448 %empty_67 to i480
  %empty_70 = shl i480 %empty_68, 448
  %empty_71 = or i480 %empty_70, %empty_69
  %empty_72 = zext i32 %0 to i512
  %empty_73 = zext i480 %empty_71 to i512
  %empty_74 = shl i512 %empty_72, 480
  %empty_75 = or i512 %empty_74, %empty_73
  ret i512 %empty_75
}

define weak i492 @_ssdm_op_BitConcatenate.i492.i12.i32.i32.i32.i32.i32.i32.i32.i32.i32.i32.i32.i32.i32.i32.i32(i12, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32) nounwind readnone {
entry:
  %empty = zext i32 %14 to i64
  %empty_76 = zext i32 %15 to i64
  %empty_77 = shl i64 %empty, 32
  %empty_78 = or i64 %empty_77, %empty_76
  %empty_79 = zext i32 %13 to i96
  %empty_80 = zext i64 %empty_78 to i96
  %empty_81 = shl i96 %empty_79, 64
  %empty_82 = or i96 %empty_81, %empty_80
  %empty_83 = zext i32 %12 to i128
  %empty_84 = zext i96 %empty_82 to i128
  %empty_85 = shl i128 %empty_83, 96
  %empty_86 = or i128 %empty_85, %empty_84
  %empty_87 = zext i32 %11 to i160
  %empty_88 = zext i128 %empty_86 to i160
  %empty_89 = shl i160 %empty_87, 128
  %empty_90 = or i160 %empty_89, %empty_88
  %empty_91 = zext i32 %10 to i192
  %empty_92 = zext i160 %empty_90 to i192
  %empty_93 = shl i192 %empty_91, 160
  %empty_94 = or i192 %empty_93, %empty_92
  %empty_95 = zext i32 %9 to i224
  %empty_96 = zext i192 %empty_94 to i224
  %empty_97 = shl i224 %empty_95, 192
  %empty_98 = or i224 %empty_97, %empty_96
  %empty_99 = zext i32 %8 to i256
  %empty_100 = zext i224 %empty_98 to i256
  %empty_101 = shl i256 %empty_99, 224
  %empty_102 = or i256 %empty_101, %empty_100
  %empty_103 = zext i32 %7 to i288
  %empty_104 = zext i256 %empty_102 to i288
  %empty_105 = shl i288 %empty_103, 256
  %empty_106 = or i288 %empty_105, %empty_104
  %empty_107 = zext i32 %6 to i320
  %empty_108 = zext i288 %empty_106 to i320
  %empty_109 = shl i320 %empty_107, 288
  %empty_110 = or i320 %empty_109, %empty_108
  %empty_111 = zext i32 %5 to i352
  %empty_112 = zext i320 %empty_110 to i352
  %empty_113 = shl i352 %empty_111, 320
  %empty_114 = or i352 %empty_113, %empty_112
  %empty_115 = zext i32 %4 to i384
  %empty_116 = zext i352 %empty_114 to i384
  %empty_117 = shl i384 %empty_115, 352
  %empty_118 = or i384 %empty_117, %empty_116
  %empty_119 = zext i32 %3 to i416
  %empty_120 = zext i384 %empty_118 to i416
  %empty_121 = shl i416 %empty_119, 384
  %empty_122 = or i416 %empty_121, %empty_120
  %empty_123 = zext i32 %2 to i448
  %empty_124 = zext i416 %empty_122 to i448
  %empty_125 = shl i448 %empty_123, 416
  %empty_126 = or i448 %empty_125, %empty_124
  %empty_127 = zext i32 %1 to i480
  %empty_128 = zext i448 %empty_126 to i480
  %empty_129 = shl i480 %empty_127, 448
  %empty_130 = or i480 %empty_129, %empty_128
  %empty_131 = zext i12 %0 to i492
  %empty_132 = zext i480 %empty_130 to i492
  %empty_133 = shl i492 %empty_131, 480
  %empty_134 = or i492 %empty_133, %empty_132
  ret i492 %empty_134
}

define weak i12 @_ssdm_op_BitConcatenate.i12.i8.i4(i8, i4) nounwind readnone {
entry:
  %empty = zext i8 %0 to i12
  %empty_135 = zext i4 %1 to i12
  %empty_136 = shl i12 %empty, 4
  %empty_137 = or i12 %empty_136, %empty_135
  ret i12 %empty_137
}

!opencl.kernels = !{!0, !7, !13, !13, !16, !16, !22, !25, !16, !31, !31, !13, !13, !16, !16, !33, !13, !13, !16, !16, !13, !13, !16, !16, !13, !13, !16, !16, !13, !13, !16, !16, !13, !13, !16, !16, !35, !16, !37, !40, !40, !16, !42, !16, !16, !16, !44, !44, !46, !47, !49, !51, !53, !16, !55, !58, !60, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16}
!hls.encrypted.func = !{}
!llvm.map.gv = !{!62}

!0 = metadata !{null, metadata !1, metadata !2, metadata !3, metadata !4, metadata !5, metadata !6}
!1 = metadata !{metadata !"kernel_arg_addr_space", i32 0, i32 0, i32 0, i32 0, i32 0}
!2 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none", metadata !"none", metadata !"none", metadata !"none", metadata !"none"}
!3 = metadata !{metadata !"kernel_arg_type", metadata !"STREAM_128 &", metadata !"STREAM_512 &", metadata !"uint16_t", metadata !"uint32_t", metadata !"uint16_t"}
!4 = metadata !{metadata !"kernel_arg_type_qual", metadata !"", metadata !"", metadata !"", metadata !"", metadata !""}
!5 = metadata !{metadata !"kernel_arg_name", metadata !"in_stream0", metadata !"out_stream", metadata !"N_ADDS", metadata !"TEST_MODE", metadata !"K_TLAST"}
!6 = metadata !{metadata !"reqd_work_group_size", i32 1, i32 1, i32 1}
!7 = metadata !{null, metadata !8, metadata !9, metadata !10, metadata !11, metadata !12, metadata !6}
!8 = metadata !{metadata !"kernel_arg_addr_space", i32 0}
!9 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none"}
!10 = metadata !{metadata !"kernel_arg_type", metadata !"const struct ap_axis<512, 8, 5, 6> &"}
!11 = metadata !{metadata !"kernel_arg_type_qual", metadata !""}
!12 = metadata !{metadata !"kernel_arg_name", metadata !"din"}
!13 = metadata !{null, metadata !8, metadata !9, metadata !14, metadata !11, metadata !15, metadata !6}
!14 = metadata !{metadata !"kernel_arg_type", metadata !"int"}
!15 = metadata !{metadata !"kernel_arg_name", metadata !"val"}
!16 = metadata !{null, metadata !17, metadata !18, metadata !19, metadata !20, metadata !21, metadata !6}
!17 = metadata !{metadata !"kernel_arg_addr_space"}
!18 = metadata !{metadata !"kernel_arg_access_qual"}
!19 = metadata !{metadata !"kernel_arg_type"}
!20 = metadata !{metadata !"kernel_arg_type_qual"}
!21 = metadata !{metadata !"kernel_arg_name"}
!22 = metadata !{null, metadata !8, metadata !9, metadata !23, metadata !11, metadata !24, metadata !6}
!23 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<512, false> &"}
!24 = metadata !{metadata !"kernel_arg_name", metadata !"op2"}
!25 = metadata !{null, metadata !26, metadata !27, metadata !28, metadata !29, metadata !30, metadata !6}
!26 = metadata !{metadata !"kernel_arg_addr_space", i32 0, i32 0}
!27 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none", metadata !"none"}
!28 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<512, false> &", metadata !"int"}
!29 = metadata !{metadata !"kernel_arg_type_qual", metadata !"", metadata !""}
!30 = metadata !{metadata !"kernel_arg_name", metadata !"op", metadata !"op2"}
!31 = metadata !{null, metadata !8, metadata !9, metadata !32, metadata !11, metadata !15, metadata !6}
!32 = metadata !{metadata !"kernel_arg_type", metadata !"uint"}
!33 = metadata !{null, metadata !8, metadata !9, metadata !34, metadata !11, metadata !24, metadata !6}
!34 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int<512> &"}
!35 = metadata !{null, metadata !8, metadata !9, metadata !36, metadata !11, metadata !24, metadata !6}
!36 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_uint<64> &"}
!37 = metadata !{null, metadata !26, metadata !27, metadata !38, metadata !29, metadata !39, metadata !6}
!38 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<128, true> &", metadata !"int"}
!39 = metadata !{metadata !"kernel_arg_name", metadata !"op", metadata !"i_op"}
!40 = metadata !{null, metadata !8, metadata !9, metadata !14, metadata !11, metadata !41, metadata !6}
!41 = metadata !{metadata !"kernel_arg_name", metadata !"op"}
!42 = metadata !{null, metadata !26, metadata !27, metadata !43, metadata !29, metadata !30, metadata !6}
!43 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<128, true> &", metadata !"const ap_int_base<32, true> &"}
!44 = metadata !{null, metadata !8, metadata !9, metadata !45, metadata !11, metadata !41, metadata !6}
!45 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<32, true> &"}
!46 = metadata !{null, metadata !26, metadata !27, metadata !38, metadata !29, metadata !30, metadata !6}
!47 = metadata !{null, metadata !8, metadata !9, metadata !48, metadata !11, metadata !24, metadata !6}
!48 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_uint<6> &"}
!49 = metadata !{null, metadata !8, metadata !9, metadata !50, metadata !11, metadata !24, metadata !6}
!50 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_uint<5> &"}
!51 = metadata !{null, metadata !8, metadata !9, metadata !52, metadata !11, metadata !24, metadata !6}
!52 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_uint<1> &"}
!53 = metadata !{null, metadata !8, metadata !9, metadata !54, metadata !11, metadata !24, metadata !6}
!54 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_uint<8> &"}
!55 = metadata !{null, metadata !8, metadata !9, metadata !56, metadata !11, metadata !57, metadata !6}
!56 = metadata !{metadata !"kernel_arg_type", metadata !"const struct ap_axis<128, 8, 5, 6> &"}
!57 = metadata !{metadata !"kernel_arg_name", metadata !""}
!58 = metadata !{null, metadata !8, metadata !9, metadata !59, metadata !11, metadata !24, metadata !6}
!59 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_uint<16> &"}
!60 = metadata !{null, metadata !8, metadata !9, metadata !61, metadata !11, metadata !24, metadata !6}
!61 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int<128> &"}
!62 = metadata !{metadata !63, [0 x i32]* @llvm_global_ctors_0}
!63 = metadata !{metadata !64}
!64 = metadata !{i32 0, i32 31, metadata !65}
!65 = metadata !{metadata !66}
!66 = metadata !{metadata !"llvm.global_ctors.0", metadata !67, metadata !"", i32 0, i32 31}
!67 = metadata !{metadata !68}
!68 = metadata !{i32 0, i32 0, i32 1}
!69 = metadata !{metadata !70}
!70 = metadata !{i32 0, i32 127, metadata !71}
!71 = metadata !{metadata !72}
!72 = metadata !{metadata !"in_stream0.V.data.V", metadata !67, metadata !"int128", i32 0, i32 127}
!73 = metadata !{metadata !74}
!74 = metadata !{i32 0, i32 15, metadata !75}
!75 = metadata !{metadata !76}
!76 = metadata !{metadata !"in_stream0.V.keep.V", metadata !67, metadata !"uint16", i32 0, i32 15}
!77 = metadata !{metadata !78}
!78 = metadata !{i32 0, i32 15, metadata !79}
!79 = metadata !{metadata !80}
!80 = metadata !{metadata !"in_stream0.V.strb.V", metadata !67, metadata !"uint16", i32 0, i32 15}
!81 = metadata !{metadata !82}
!82 = metadata !{i32 0, i32 7, metadata !83}
!83 = metadata !{metadata !84}
!84 = metadata !{metadata !"in_stream0.V.user.V", metadata !67, metadata !"uint8", i32 0, i32 7}
!85 = metadata !{metadata !86}
!86 = metadata !{i32 0, i32 0, metadata !87}
!87 = metadata !{metadata !88}
!88 = metadata !{metadata !"in_stream0.V.last.V", metadata !67, metadata !"uint1", i32 0, i32 0}
!89 = metadata !{metadata !90}
!90 = metadata !{i32 0, i32 4, metadata !91}
!91 = metadata !{metadata !92}
!92 = metadata !{metadata !"in_stream0.V.id.V", metadata !67, metadata !"uint5", i32 0, i32 4}
!93 = metadata !{metadata !94}
!94 = metadata !{i32 0, i32 5, metadata !95}
!95 = metadata !{metadata !96}
!96 = metadata !{metadata !"in_stream0.V.dest.V", metadata !67, metadata !"uint6", i32 0, i32 5}
!97 = metadata !{metadata !98}
!98 = metadata !{i32 0, i32 511, metadata !99}
!99 = metadata !{metadata !100}
!100 = metadata !{metadata !"out_stream.V.data.V", metadata !67, metadata !"int512", i32 0, i32 511}
!101 = metadata !{metadata !102}
!102 = metadata !{i32 0, i32 63, metadata !103}
!103 = metadata !{metadata !104}
!104 = metadata !{metadata !"out_stream.V.keep.V", metadata !67, metadata !"uint64", i32 0, i32 63}
!105 = metadata !{metadata !106}
!106 = metadata !{i32 0, i32 63, metadata !107}
!107 = metadata !{metadata !108}
!108 = metadata !{metadata !"out_stream.V.strb.V", metadata !67, metadata !"uint64", i32 0, i32 63}
!109 = metadata !{metadata !110}
!110 = metadata !{i32 0, i32 7, metadata !111}
!111 = metadata !{metadata !112}
!112 = metadata !{metadata !"out_stream.V.user.V", metadata !67, metadata !"uint8", i32 0, i32 7}
!113 = metadata !{metadata !114}
!114 = metadata !{i32 0, i32 0, metadata !115}
!115 = metadata !{metadata !116}
!116 = metadata !{metadata !"out_stream.V.last.V", metadata !67, metadata !"uint1", i32 0, i32 0}
!117 = metadata !{metadata !118}
!118 = metadata !{i32 0, i32 4, metadata !119}
!119 = metadata !{metadata !120}
!120 = metadata !{metadata !"out_stream.V.id.V", metadata !67, metadata !"uint5", i32 0, i32 4}
!121 = metadata !{metadata !122}
!122 = metadata !{i32 0, i32 5, metadata !123}
!123 = metadata !{metadata !124}
!124 = metadata !{metadata !"out_stream.V.dest.V", metadata !67, metadata !"uint6", i32 0, i32 5}
!125 = metadata !{metadata !126}
!126 = metadata !{i32 0, i32 15, metadata !127}
!127 = metadata !{metadata !128}
!128 = metadata !{metadata !"N_ADDS", metadata !129, metadata !"unsigned short", i32 0, i32 15}
!129 = metadata !{metadata !130}
!130 = metadata !{i32 0, i32 0, i32 0}
!131 = metadata !{metadata !132}
!132 = metadata !{i32 0, i32 31, metadata !133}
!133 = metadata !{metadata !134}
!134 = metadata !{metadata !"TEST_MODE", metadata !129, metadata !"unsigned int", i32 0, i32 31}
!135 = metadata !{metadata !136}
!136 = metadata !{i32 0, i32 15, metadata !137}
!137 = metadata !{metadata !138}
!138 = metadata !{metadata !"K_TLAST", metadata !129, metadata !"unsigned short", i32 0, i32 15}
