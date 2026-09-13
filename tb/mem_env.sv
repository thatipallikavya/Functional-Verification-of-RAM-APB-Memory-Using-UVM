class environment extends uvm_env;
        `uvm_component_utils(environment)
        apb_agent apb_agt;
        test_config test_cfg;
        apb_scoreboard sb;
extern function new(string name="environment",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
endclass
function environment::new(string name="environment",uvm_component parent);
        super.new(name,parent);
endfunction
function void environment::build_phase(uvm_phase phase);
        uvm_config_db#(test_config)::get(this,"","test_config",test_cfg);
        if(test_cfg.has_apb_agt==1)
                apb_agt=apb_agent::type_id::create("apb_agt",this);
                sb=apb_scoreboard::type_id::create("sb",this);
endfunction
function void environment::connect_phase(uvm_phase phase);
        apb_agt.mon.monitor_port.connect(sb.sb_port.analysis_export);
endfunction
