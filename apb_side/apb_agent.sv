class apb_agent extends uvm_agent;
        `uvm_component_utils(apb_agent)
        apb_driver drv;
        apb_monitor mon;
        apb_sequencer seqr;
        apb_config apb_cfg;
extern function new(string name="apb_agent",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
endclass
function apb_agent::new(string name="apb_agent",uvm_component parent);
        super.new(name,parent);
endfunction
function void apb_agent::build_phase(uvm_phase phase);
uvm_config_db#(apb_config)::get(this,"","apb_config",apb_cfg);
        if(apb_cfg.is_active==UVM_ACTIVE)
        begin
                drv=apb_driver::type_id::create("drv",this);
                seqr=apb_sequencer::type_id::create("seqr",this);
        end
                mon=apb_monitor::type_id::create("mon",this);
endfunction
function void apb_agent::connect_phase(uvm_phase phase);
        if(apb_cfg.is_active==UVM_ACTIVE)
        drv.seq_item_port.connect(seqr.seq_item_export);
endfunction
