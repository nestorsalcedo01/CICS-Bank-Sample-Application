package com.ibm.cics.cip.bank.springboot.customerservices.jsonclasses.listaccounts;

import com.fasterxml.jackson.databind.annotation.JsonNaming;
import com.ibm.cics.cip.bank.springboot.customerservices.JsonPropertyNamingStrategy;

@JsonNaming(JsonPropertyNamingStrategy.class)
public class ListAccJson {
    
    private InqAccczJson INQACCCZ;

    public ListAccJson() {

    }

    public InqAccczJson getINQACCCZ() {
        return INQACCCZ;
    }

    public void setINQACCCZ(InqAccczJson iNQACCCZ) {
        INQACCCZ = iNQACCCZ;
    }

    @Override
    public String toString() {
        return "ListAccJson [INQACCCZ=" + INQACCCZ + "]";
    }
}
